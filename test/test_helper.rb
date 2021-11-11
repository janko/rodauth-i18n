ENV["RACK_ENV"] = "test"

require "bundler/setup"

require "minitest/autorun"
require "minitest/pride"
require "minitest/hooks/default"

require "capybara/dsl"
require "securerandom"
require "rodauth/i18n"

require "rodauth"
require "sequel/core"
require "roda"

DB = Sequel.connect("#{"jdbc:" if RUBY_ENGINE == "jruby"}sqlite::memory")

DB.create_table :accounts do
  primary_key :id
  String :email, null: false
  String :password_hash
end

I18n.available_locales = [:en, :hr]
Rodauth::I18n.add

class Minitest::HooksSpec
  include Capybara::DSL

  private

  attr_reader :app

  def app=(app)
    @app = Capybara.app = app
  end

  def rodauth(&block)
    @rodauth_block = block
  end

  def roda(**options, &block)
    app = Class.new(Roda)
    app.plugin :sessions, secret: SecureRandom.hex(32), key: "rack.session"
    app.plugin :render, layout_opts: { path: "test/views/layout.str" }

    rodauth_block = @rodauth_block
    app.plugin(:rodauth, **options) do
      instance_exec(&rodauth_block)
      account_password_hash_column :password_hash
      title_instance_variable :@page_title
    end
    app.route(&block)

    self.app = app
  end

  before do
    I18n.reload!
  end

  around do |&block|
    DB.transaction(rollback: :always, auto_savepoint: true) do
      super(&block)
    end
  end

  after do
    Capybara.reset_sessions!
  end
end
