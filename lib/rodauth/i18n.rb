# frozen_string_literal: true

require "i18n"
require "rodauth/i18n/railtie" if defined?(Rails)

module Rodauth
  module I18n
    def self.add(locales = nil)
      ::I18n.load_path.concat files(locales)
    end

    def self.files(locales = nil)
      directory_pattern = "{#{directories.join(",")}}"

      if ::I18n.available_locales_initialized?
        locales ||= ::I18n.available_locales
        file_pattern = "{#{locales.join(",")}}"
      else
        file_pattern = "*"
      end

      Dir["#{directory_pattern}/#{file_pattern}.yml"]
    end

    def self.directories
      @directories ||= [File.expand_path("#{__dir__}/../../locales")]
    end
  end
end
