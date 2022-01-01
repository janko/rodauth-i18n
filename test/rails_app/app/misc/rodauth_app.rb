class RodauthApp < Rodauth::Rails::App
  configure do
    enable :i18n, :login, :verify_account
    rails_controller { RodauthController }
  end

  route do |r|
    r.rodauth
  end
end
