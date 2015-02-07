require "cgi"
require_relative "base"

module Redd
  module Clients
    class Installed < Base
      # @!attribute [r] client_id
      attr_reader :client_id

      # @!attribute [r] redirect_uri
      attr_reader :redirect_uri

      # Set up an unauthenticated connection to reddit.
      # @param [Hash] options The options to create the client with.
      # @see {Redd.it}
      def initialize(client_id, redirect_uri, **options)
        @client_id = client_id
        @redirect_uri = redirect_uri
        super(**options)
      end

      def auth_url(state, scopes = ["identity"], duration = :temporary)
        query = {
          response_type: "token",
          client_id: @client_id,
          redirect_uri: @redirect_uri,
          state: state,
          scope: scopes.join(","),
          duration: duration
        }

        url = URI.join(auth_endpoint, "/api/v1/authorize")
        url.query = URI.encode_www_form(query)
        url.to_s
      end

      def authorize!(fragment)
        parsed = CGI.parse(fragment)
        @access = Access.new(
          access_token: parsed[:access_token].first,
          expires_in: parsed[:expires_in].first,
          scope: parsed[:scope]
        )
      end
    end
  end
end
