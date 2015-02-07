require "uri"
require_relative "base"

module Redd
  module Clients
    class Web < Base
      # @!attribute [r] client_id
      attr_reader :client_id

      # @!attribute [r] redirect_uri
      attr_reader :redirect_uri

      # Set up an unauthenticated connection to reddit.
      # @param [Hash] options The options to create the client with.
      # @see {Redd.it}
      def initialize(client_id, secret, redirect_uri, **options)
        @client_id = client_id
        @secret = secret
        @redirect_uri = redirect_uri
        super(**options)
      end

      def auth_url(state, scopes = ["identity"], duration = :temporary)
        query = {
          response_type: "code",
          client_id: @client_id,
          redirect_uri: @redirect_uri,
          state: state,
          scope: scopes.join(","),
          duration: duration
        }

        url = URI.join(auth_endpoint, "/api/v1/authorize")
        url.query = query.to_a
        url.to_s
      end

      def authorize!(code)
        response = auth_connection.post(
          "/api/v1/access_token",
          grant_type: "authorization_code",
          code: code,
          redirect_uri: @redirect_uri
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
