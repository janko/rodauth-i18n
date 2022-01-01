require "test_helper"
require_relative "../rails_app/config/environment"
require "generators/rodauth/translations_generator"

class InstallGeneratorTest < Rails::Generators::TestCase
  tests Rodauth::Rails::TranslationsGenerator
  destination File.expand_path("#{__dir__}/../../tmp")
  setup :prepare_destination

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
end
