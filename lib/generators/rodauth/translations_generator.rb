require "rails/generators"
require "active_support/core_ext/hash/slice"

module Rodauth
  module Rails
    class TranslationsGenerator < ::Rails::Generators::Base
      source_root File.expand_path("#{__dir__}/../../../locales")
      namespace "rodauth:translations"

      argument :selected_locales, type: :array, required: false,
        desc: "List of locales to copy translation files for"

      def copy_locales
        say "No locales specified!", :yellow if locales.empty?

        locales.each do |locale|
          translations = retrieve_translations(locale)

          if translations.empty?
            say "No translations for locale: #{locale}", :yellow
            next
          end

          # retain translations the user potentially changed
          translations.merge!(existing_translations(locale))
          # keep only translations for currently enabled features
          translations.slice!(*rodauth_methods)

          create_file "config/locales/rodauth.#{locale}.yml", locale_content(locale, translations)
        end
      end

      private

      def retrieve_translations(locale)
        files = translation_files(locale)
        files.inject({}) do |translations, file|
          translations.merge YAML.load_file(file)[locale]["rodauth"]
        end
      end

      def existing_translations(locale)
        destination = File.join(destination_root, "config/locales/rodauth.#{locale}.yml")

        # try to load existing translations first
        if File.exist?(destination)
          YAML.load_file(destination)[locale]["rodauth"]
        else
          {}
        end
      end

      def translation_files(locale)
        # ensure Rodauth configuration ran in autoloaded environment
        Rodauth::Rails.app

        Rodauth::I18n.directories
          .map { |directory| Dir["#{directory}/#{locale}.yml"] }
          .inject(:+)
      end

      def rodauth_methods
        rodauths
          .flat_map { |rodauth| rodauth.instance_methods - Object.instance_methods }
          .map(&:to_s)
          .sort
      end

      def locale_content(locale, translations)
        data = { locale => { "rodauth" => translations } }
        yaml = YAML.dump(data, line_width: 10_000) # disable line wrapping
        yaml.split("\n", 2).last # remove "---" header
      end

      def locales
        selected_locales || available_locales.map(&:to_s)
      end

      def available_locales
        rodauths.inject([]) do |locales, rodauth|
          locales |= rodauth.allocate.send(:i18n_available_locales) || []
        end
      end

      def rodauths
        Rodauth::Rails.app.opts[:rodauths].values
      end
    end
  end
end
