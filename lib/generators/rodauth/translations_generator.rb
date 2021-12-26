require "rails/generators/base"

module Rodauth
  module Rails
    class TranslationsGenerator < ::Rails::Generators::Base
      source_root File.expand_path("#{__dir__}/../../../locales")
      namespace "rodauth:translations"

      argument :selected_locales, type: :array, required: false,
        desc: "List of locales to copy translation files for"

      def copy_locales
        locales.each do |locale|
          copy_file("#{locale}.yml", "config/locales/rodauth.#{locale}.yml")
        end

        say "No locales specified!", :yellow if locales.empty?
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
