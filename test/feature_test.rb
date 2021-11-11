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
    click_on "Stvori korisnički račun"
    assert_equal "Vaš korisnički račun je stvoren", find("#notice_flash").text
  end

  it "picks up configuration-specific translations" do
    I18n.backend.store_translations(:en, { rodauth: { admin: { login_label: "Admin Login" } } })

    rodauth do
      enable :i18n, :login
    end
    roda(name: :admin) do |r|
      r.rodauth(:admin)
      r.root { view content: "" }
    end

    visit "/login"
    assert_match "Admin Login", page.text
    assert_match "Password", page.text
  end

  it "allows configuring translation namespace" do
    I18n.backend.store_translations(:en, { rodauth: { admin: { login_label: "Admin Login" } } })

    rodauth do
      enable :i18n, :login
      i18n_namespace "admin"
    end
    roda do |r|
      r.rodauth
      r.root { view content: "" }
    end

    visit "/login"
    assert_match "Admin Login", page.text
    assert_match "Password", page.text
  end

  it "doesn't cascade to top-level translation namespace if configured" do
    I18n.backend.store_translations(:en, { rodauth: { admin: { login_label: "Admin Login" } } })

    rodauth do
      enable :i18n, :login
      i18n_cascade? false
    end
    roda(name: :admin) do |r|
      r.rodauth(:admin)
      r.root { view content: "" }
    end

    visit "/login"
    assert_match "Admin Login", page.text
    assert_match "translation missing: en.rodauth.admin.password_label", page.text
  end

  it "returns missing translation by default" do
    Rodauth::Feature.define(:foo) { translatable_method :foo, "Foo Bar" }

    rodauth do
      enable :i18n, :foo
    end
    roda do |r|
      r.rodauth
      r.root { view content: rodauth.foo }
    end

    visit "/"
    assert_match "translation missing: en.rodauth.foo", page.html
  end

  it "falls back to auth value when configured" do
    Rodauth::Feature.define(:foo) { translatable_method :foo, "Foo Bar" }

    rodauth do
      enable :i18n, :foo
      i18n_fallback_to_untranslated? true
    end
    roda do |r|
      r.rodauth
      r.root { view content: rodauth.foo }
    end

    visit "/"
    assert_match "Foo Bar", page.html
  end

  it "allows raising on missing translation" do
    Rodauth::Feature.define(:foo) { translatable_method :foo, "Foo Bar" }

    rodauth do
      enable :i18n, :foo
      i18n_raise_on_missing_translations? true
    end
    roda do |r|
      r.rodauth
      r.root { view content: rodauth.foo }
    end

    error = assert_raises I18n::MissingTranslationData do
      visit "/"
    end

    assert_equal "translation missing: en.rodauth.foo", error.message
  end

  it "still raises when fallback is configured" do
    Rodauth::Feature.define(:foo) { translatable_method :foo, "Foo Bar" }

    rodauth do
      enable :i18n, :foo
      i18n_raise_on_missing_translations? true
      i18n_fallback_to_untranslated? true
    end
    roda do |r|
      r.rodauth
      r.root { view content: rodauth.foo }
    end

    assert_raises I18n::MissingTranslationData do
      visit "/"
    end
  end
end
