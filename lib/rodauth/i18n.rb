# frozen_string_literal: true

require "i18n"
require "rodauth/i18n/railtie" if defined?(Rails)

module Rodauth
  module I18n
    def self.add(locales = nil)
      if ::I18n.available_locales_initialized?
        locales ||= ::I18n.available_locales
        pattern = "{#{locales.join(",")}}"
      else
        pattern = "*"
      end

      files = Dir["#{__dir__}/../../locales/#{pattern}.yml"]

      ::I18n.load_path.concat files
    end
  end
end
