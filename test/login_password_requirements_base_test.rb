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

  it "translates password too short message" do
    rodauth do
      enable :i18n, :create_account
      require_login_confirmation? false
      require_password_confirmation? false
      password_minimum_length 3
      i18n_locale { :hr }
    end
    roda do |r|
      r.rodauth
    end

    visit "/create-account"
    fill_in "Email adresa", with: "user@example.com"
    fill_in "Lozinka", with: "a"
    click_on "Stvori korisnički račun"
    assert_includes page.text, "neispravna lozinka, ne ispunjava uvjete (najmanje 3 znakova)"
  end

  it "translates password too long message" do
    rodauth do
      enable :i18n, :create_account
      require_login_confirmation? false
      require_password_confirmation? false
      password_maximum_length 72
      i18n_locale { :hr }
    end
    roda do |r|
      r.rodauth
    end

    visit "/create-account"
    fill_in "Email adresa", with: "user@example.com"
    fill_in "Lozinka", with: "a" * 73
    click_on "Stvori korisnički račun"
    assert_includes page.text, "neispravna lozinka, ne ispunjava uvjete (najviše 72 znakova)"
  end

  it "translates password too many bytes message" do
    rodauth do
      enable :i18n, :create_account
      require_login_confirmation? false
      require_password_confirmation? false
      password_maximum_bytes 72
      i18n_locale { :hr }
    end
    roda do |r|
      r.rodauth
    end

    visit "/create-account"
    fill_in "Email adresa", with: "user@example.com"
    fill_in "Lozinka", with: "a" * 73
    click_on "Stvori korisnički račun"
    assert_includes page.text, "neispravna lozinka, ne ispunjava uvjete (najviše 72 bajtova)"
  end

  it "translates login too short message" do
    rodauth do
      enable :i18n, :create_account
      require_login_confirmation? false
      require_password_confirmation? false
      login_minimum_length 3
      i18n_locale { :hr }
    end
    roda do |r|
      r.rodauth
    end

    visit "/create-account"
    fill_in "Email adresa", with: "a"
    click_on "Stvori korisnički račun"
    assert_includes page.text, "neispravna email adresa, ne ispunjava uvjete (najmanje 3 znakova)"
  end

  it "translates login too long message" do
    rodauth do
      enable :i18n, :create_account
      require_login_confirmation? false
      require_password_confirmation? false
      login_maximum_length 255
      i18n_locale { :hr }
    end
    roda do |r|
      r.rodauth
    end

    visit "/create-account"
    fill_in "Email adresa", with: "a" * 256
    click_on "Stvori korisnički račun"
    assert_includes page.text, "neispravna email adresa, ne ispunjava uvjete (najviše 255 znakova)"
  end

  it "translates login too many bytes message" do
    rodauth do
      enable :i18n, :create_account
      require_login_confirmation? false
      require_password_confirmation? false
      login_maximum_bytes 100
      i18n_locale { :hr }
    end
    roda do |r|
      r.rodauth
    end

    visit "/create-account"
    fill_in "Email adresa", with: "a" * 101
    click_on "Stvori korisnički račun"
    assert_includes page.text, "neispravna email adresa, ne ispunjava uvjete (najviše 100 bajtova)"
  end
end
