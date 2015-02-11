require_relative "base"

module Redd
  module Clients
    class Script < Base
      # @!attribute [r] client_id
      attr_reader :client_id

      # @!attribute [r] username
      attr_reader :username

      # @param [Hash] options The options to create the client with.
      # @see Redd.it
      def initialize(client_id, secret, username, password, **options)
        @client_id = client_id
        @secret = secret
        @username = username
        @password = password
        super(**options)
      end

      # Authorize using the given data.
      # @return [Access] The access given by reddit.
      def authorize!
        response = auth_connection.post(
          "/api/v1/access_token",
          grant_type: "password",
          username: @username,
          password: @password
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
