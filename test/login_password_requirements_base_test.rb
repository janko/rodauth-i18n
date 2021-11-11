require "test_helper"

describe "login password requirements base translations" do
  it "translates confirm labels" do
    rodauth do
      enable :i18n, :create_account
      i18n_locale { :hr }
    end
    roda do |r|
      r.rodauth
      r.root { view content: "" }
    end

    visit "/create-account"

    assert_includes page.text, "Potvrda email adrese"
    assert_includes page.text, "Potvrda lozinke"
  end

  it "translates validation errors" do
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
    fill_in "Email adresa", with: "a"
    click_on "Stvori korisnički račun"
    assert_includes page.text, "neispravna email adresa, ne ispunjava uvjete (najmanje 3 znakova)"

    fill_in "Email adresa", with: "a" * 300
    click_on "Stvori korisnički račun"
    assert_includes page.text, "neispravna email adresa, ne ispunjava uvjete (najviše 255 znakova)"

    fill_in "Email adresa", with: "user@example.com"
    fill_in "Lozinka", with: "s"
    click_on "Stvori korisnički račun"
    assert_includes page.text, "neispravna lozinka, ne ispunjava uvjete (najmanje 6 znakova)"
  end
end
