require "rails/generators"

module Rodauth
  module Rails
    class TranslationsGenerator < ::Rails::Generators::Base
      source_root File.expand_path("#{__dir__}/../../../locales")
      namespace "rodauth:translations"

      argument :selected_locales, type: :array, required: false,
        desc: "List of locales to copy translation files for"

      def copy_locales
        say "No locales specified!", :yellow if locales.empty?

        # eager-load rodauth app
        Rodauth::Rails.app

        locales.each do |locale|
          files = translation_files(locale)

          if files.empty?
            say "No translations for locale: #{locale}", :yellow
            next
          end

          destination = File.join(destination_root, "config", "locales", "rodauth.#{locale}.yml")

          # try to load existing translations first
          translations = if File.exist?(destination)
            YAML.load_file(destination)
          else
            { locale => { "rodauth" => {} } }
          end

          files.each do |file|
            default_translations = YAML.load_file(file)[locale]["rodauth"]
            translations[locale]["rodauth"].reverse_merge!(default_translations)
          end

          create_file("config/locales/rodauth.#{locale}.yml") do |destination|
            YAML.dump(translations, line_width: 1000).split("\n", 2).last
          end
        end
      end

      private

      def translation_files(locale)
        Rodauth::I18n.directories
          .map { |directory| Dir["#{directory}/#{locale}.yml"] }
          .inject(:+)
      end

      def locales
        selected_locales || available_locales
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
