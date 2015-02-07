require_relative "base"

module Redd
  module Clients
    class Userless < Base
      # @!attribute [r] client_id
      attr_reader :client_id

      # Set up an unauthenticated connection to reddit.
      # @param [Hash] options The options to create the client with.
      # @see {Redd.it}
      def initialize(client_id, secret, **options)
        @client_id = client_id
        @secret = secret
        super(**options)
      end

      def authorize!
        response = auth_connection.post(
          "/api/v1/access_token",
          grant_type: "client_credentials"
        )

        @access = Access.new(response.body)
      end

      private

      # @return [Faraday::Connection] A new or existing connection.
      def auth_connection
        @auth_connection ||= Faraday.new(
          @auth_endpoint,
          headers: auth_headers,
          builder: middleware
        )
      end

      def auth_headers
        {
          "User-Agent" => @user_agent,
          "Authorization" => Faraday.basic_auth(@client_id, @secret)
        }
      end
    end
  end
end
