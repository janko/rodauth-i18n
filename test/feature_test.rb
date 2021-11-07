require "test_helper"

describe "i18n feature" do
  it "loads built-in locales" do
    rodauth do
      enable :i18n, :create_account
      require_login_confirmation? false
      require_password_confirmation? false
      i18n_locale { :hr }
    end
    roda do |r|
      r.rodauth
      r.root { view content: "" }
    end

    visit "/create-account"
    assert_equal "Registracija", page.title
    fill_in "Email adresa", with: "user@example.com"
    fill_in "Lozinka", with: "secret"
    click_on "Stvori račun"
    assert_equal "Vaš korisnički račun je stvoren", find("#notice_flash").text
  end
end
