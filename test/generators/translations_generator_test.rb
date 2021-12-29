# frozen_string_literal: true

require "test_helper"
require_relative "../rails_app/config/environment"
require "generators/rodauth/translations_generator"

class InstallGeneratorTest < Rails::Generators::TestCase
  tests Rodauth::Rails::TranslationsGenerator
  destination File.expand_path("#{__dir__}/../../tmp")
  setup :prepare_destination

  test "locales" do
    run_generator %w[en]

    assert_file "config/locales/rodauth.en.yml" do |translations|
      assert_match(/logout_button: Logout/, translations)
    end
  end
end
