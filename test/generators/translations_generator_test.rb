require "test_helper"
require_relative "../rails_app/config/environment"
require "generators/rodauth/translations_generator"

class InstallGeneratorTest < Rails::Generators::TestCase
  tests Rodauth::Rails::TranslationsGenerator
  destination File.expand_path("#{__dir__}/../../tmp")
  setup :prepare_destination

  test "available locales" do
    run_generator %w[en]

    assert_file "config/locales/rodauth.en.yml" do |translations|
      assert_match(/logout_button: Logout/, translations)
    end
  end

  test "new locales" do
    run_generator %w[pt]

    assert_file "config/locales/rodauth.pt.yml" do |translations|
      assert_match(/logout_button: Encerrar sessão/, translations)
    end
  end
end
