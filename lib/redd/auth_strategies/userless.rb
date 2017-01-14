# frozen_string_literal: true

require_relative 'auth_strategy'

module Redd
  module AuthStrategies
    # A userless authentication scheme.
    class Userless < AuthStrategy
      # Perform authentication and return the resulting access object
      # @return [Access] the access token object
      def authenticate
        request_access('client_credentials')
      end
      alias refresh authenticate
    end
  end
end
