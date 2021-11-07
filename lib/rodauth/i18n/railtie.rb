# frozen_string_literal: true

require "rails"

module Rodauth
  module I18n
    class Railtie < ::Rails::Railtie
      initializer "rodauth.i18n" do
        Rodauth::I18n.add
      end
    end
  end
end
