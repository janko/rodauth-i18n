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

        by_locale = Rodauth::I18n.i18n_files.select do |file|
          locales.include?(File.basename(file, ".yml"))
        end.group_by{ |file| File.basename(file, ".yml")}

        by_locale.each do |locale, files|
          destination = File.join(destination_root, "config", "locales", "rodauth.#{locale}.yml")

          # try to load existing translations first
          existing_translations = if File.exist?(destination)
            YAML.load_file(destination)
          else
            {}
          end

          data = files.reduce(existing_translations) do |translations, file|
            translations.merge(YAML.load_file(file)[locale])
          end

          create_file(destination) do |destination|
            YAML.dump({locale => data}, line_width: 1000).split("\n", 2).last
          end
        end
      end

      private

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
