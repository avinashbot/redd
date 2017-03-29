# frozen_string_literal: true

require_relative 'basic_model'

module Redd
  module Models
    # Models access_token and related keys.
    # @note This model also supports an additional key, called `:created_at` which is a UNIX time
    #   representing the time the object was created. The default value is the time the object was
    #   initialized.
    class Access < BasicModel
      def expired?(grace_period = 60)
        # We're not sure, so we just assume it hasn't expired.
        return false unless @attributes[:expires_in]
        Time.now.to_i > @attributes[:created_at] + (@attributes[:expires_in] - grace_period)
      end

      def permanent?
        !@attributes[:refresh_token].nil?
      end

      private

      def after_initialize
        @attributes[:created_at] ||= Time.now.to_i
      end
    end
  end
end
