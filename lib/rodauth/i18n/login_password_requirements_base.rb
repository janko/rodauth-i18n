module Rodauth
  module I18n
    # Dynamic translations for the login_password_requirements_base feature.
    module LoginPasswordRequirementsBase
      def self.included(feature)
        feature.depends :login_password_requirements_base
      end

      def login_confirm_label
        i18n_translate(__method__, super, login_label: login_label)
      end

      def password_confirm_label
        i18n_translate(__method__, super, password_label: password_label)
      end

      private

      def password_does_not_meet_requirements_message
        i18n_translate(__method__, super) + "#{" (#{password_requirement_message})" if password_requirement_message}"
      end

      def password_too_long_message
        i18n_translate(__method__, super, password_maximum_length: password_maximum_length)
      end

      def password_too_many_bytes_message
        i18n_translate(__method__, super, password_maximum_bytes: password_maximum_bytes)
      end

      def password_too_short_message
        i18n_translate(__method__, super, password_minimum_length: password_minimum_length)
      end

      def login_does_not_meet_requirements_message
        i18n_translate(__method__, super) + "#{" (#{login_requirement_message})" if login_requirement_message}"
      end

      def login_too_long_message
        i18n_translate(__method__, super, login_maximum_length: login_maximum_length)
      end

      def login_too_many_bytes_message
        i18n_translate(__method__, super, login_maximum_bytes: login_maximum_bytes)
      end

      def login_too_short_message
        i18n_translate(__method__, super, login_minimum_length: login_minimum_length)
      end
    end
  end
end
