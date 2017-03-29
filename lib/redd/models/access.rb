# frozen_string_literal: true

require_relative 'basic_model'

module Redd
  module Models
    # Models access_token and related keys.
    # @note This model also supports an additional key, called `:created_at` which is a UNIX time
    #   representing the time the access was created. The default value is the time the object was
    #   initialized.
    class Access < BasicModel
      # Create a non-lazily initialized Access.
      # @param client [Object] (deprecated) the client to create the object with
      # @param attributes [Hash] the Access's attributes
      # @example
      #   access = Redd::Models::Access.new(access_token: ...)
      def initialize(client = nil, attributes = {})
        if client.is_a?(Hash)
          super(nil, client)
        else
          super(client, attributes)
        end
      end

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
