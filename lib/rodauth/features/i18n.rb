require "set"
require "i18n"

module Rodauth
  Feature.define(:i18n, :I18n) do
    auth_value_method :i18n_cascade?, true
    auth_value_method :i18n_raise_on_missing_translations?, false
    auth_value_method :i18n_fallback_to_untranslated?, false
    auth_value_method :i18n_options, {}

    auth_value_methods(
      :i18n_namespace,
      :i18n_available_locales,
    )

    auth_methods(
      :i18n_locale,
    )

    @directories = Set.new

    class << self
      attr_reader :directories
    end

    def post_configure
      super
      i18n_register File.expand_path("#{__dir__}/../../../locales")
    end

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

    def i18n_default(name, fallback)
      default = []
      default << name if i18n_namespace && i18n_cascade?
      default << fallback if i18n_fallback_to_untranslated? && !i18n_raise_on_missing_translations?
      default
    end

    def i18n_namespace
      self.class.configuration_name
    end

    def i18n_register(directory)
      files = i18n_files(directory)
      files.each { |file| i18n_add(file) }
      i18n_reload
      Rodauth::I18n.directories << directory
    end

    # Returns list of translation files in given directory based on
    # available locales.
    def i18n_files(directory)
      locales = i18n_available_locales
      pattern = locales ? "{#{locales.join(",")}}" : "*"

      Dir["#{directory}/#{pattern}.yml"]
    end

    # User-defined translations have most likely already been loaded at this
    # point, so we prepend built-in translations to the load path to ensure we
    # don't override them.
    def i18n_add(file)
      ::I18n.load_path.unshift(file) unless ::I18n.load_path.include?(file)
    end

    # Ensure we pick up new entries in the load path.
    def i18n_reload
      ::I18n.reload!
    end

    # Returns available locales if they have been set.
    def i18n_available_locales
      ::I18n.available_locales if ::I18n.available_locales_initialized?
    end

    def i18n_scope
      "rodauth"
    end
  end
end

require "rodauth/i18n/login_password_requirements_base"
Rodauth::I18n.include Rodauth::I18n::LoginPasswordRequirementsBase
