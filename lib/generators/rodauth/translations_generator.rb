require "rails/generators/base"

module Rodauth
  module Rails
    class TranslationsGenerator < ::Rails::Generators::Base
      source_root File.expand_path("#{__dir__}/../../../locales")
      namespace "rodauth:translations"

      argument :locales, type: :array,
        desc: "List of locales to copy translation files for"

      def copy_locales
        locales.each do |locale|
          copy_file("#{locale}.yml", "config/locales/rodauth.#{locale}.yml")
        end
      end
    end
  end
end
