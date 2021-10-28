require "i18n"

class Rodauth
  Feature.define(:i18n, :I18n) do
    auth_value_method :i18n_options, {}

    def translate(key, default)
      ::I18n.translate("rodauth.#{key}", **i18n_options)
    end
  end
end
