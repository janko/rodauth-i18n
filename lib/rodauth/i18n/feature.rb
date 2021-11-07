require "rodauth/i18n/login_password_requirements_base"
require "i18n"

module Rodauth
  Feature.define(:i18n) do
    include Rodauth::I18n::LoginPasswordRequirementsBase

    auth_value_method :i18n_cascade?, true
    auth_value_method :i18n_raise_on_missing_translations?, false
    auth_value_method :i18n_fallback?, false
    auth_value_method :i18n_options, {}

    auth_value_methods(
      :i18n_namespace,
    )

    auth_methods(
      :i18n_locale,
    )

    def translate(name, default)
      i18n_translate(name, default)
    end

    def i18n_locale
      ::I18n.locale
    end

    private

    def i18n_translate(name, default, **options)
      ::I18n.translate(i18n_translation_key(name),
        scope: i18n_scope,
        locale: i18n_locale,
        raise: i18n_raise_on_missing_translations?,
        default: i18n_default(name, default),
        **i18n_options,
        **options
      )
    end

    def i18n_translation_key(name)
      [*i18n_namespace, name].join(".")
    end

    def i18n_default(name, default)
      default = []
      default << name if i18n_namespace && i18n_cascade?
      default << default if i18n_fallback? && !i18n_raise_on_missing_translations?
      default
    end

    def i18n_namespace
      self.class.configuration_name
    end

    def i18n_scope
      "rodauth"
    end
  end

  # Assign feature and feature configuration to constants for introspection.
  I18n::Feature              = FEATURES[:i18n]
  I18n::FeatureConfiguration = FEATURES[:i18n].configuration
end
