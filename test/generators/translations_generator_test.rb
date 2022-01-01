require "test_helper"
require_relative "../rails_app/config/environment"
require "generators/rodauth/translations_generator"

class InstallGeneratorTest < Rails::Generators::TestCase
  tests Rodauth::Rails::TranslationsGenerator
  destination File.expand_path("#{__dir__}/../../tmp")
  setup :prepare_destination

  teardown do
    I18n.available_locales = [:en, :hr]
  end

  test "available locales" do
    run_generator %w[en]

    assert_file "config/locales/rodauth.en.yml" do |content|
      translations = YAML.load(content)
      assert_equal "Logout", translations["en"]["rodauth"]["logout_button"]
    end
  end

  test "new locales" do
    run_generator %w[pt]

    assert_file "config/locales/rodauth.pt.yml" do |content|
      translations = YAML.load(content)
      assert_equal "Encerrar sessão", translations["pt"]["rodauth"]["logout_button"]
    end
  end

  test "existing translations" do
    path = File.join(destination_root, "config/locales/rodauth.en.yml")
    mkdir_p File.dirname(path)
    File.write(path, <<~YAML)
      en:
        rodauth:
          login_label: Email
    YAML

    run_generator %w[en --force]

    assert_file "config/locales/rodauth.en.yml" do |content|
      translations = YAML.load(content)
      assert_equal "Email", translations["en"]["rodauth"]["login_label"]
      assert_equal "Password", translations["en"]["rodauth"]["password_label"]
    end
  end

  test "unknown locales" do
    output = run_generator %w[xy]

    assert_equal "No translations for locale: xy", output.split("\n").first
    assert_no_file "config/locales/rodauth.xy.yml"
  end

  test "no locales" do
    I18n.available_locales = nil

    output = run_generator %w[]

    assert_equal "No locales specified!", output.strip
  end
end
