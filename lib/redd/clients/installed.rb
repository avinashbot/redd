require "cgi"
require_relative "base"

module Redd
  module Clients
    class Installed < Base
      # @!attribute [r] client_id
      attr_reader :client_id

      # @!attribute [r] redirect_uri
      attr_reader :redirect_uri

      # @param [Hash] options The options to create the client with.
      # @see {Redd.it}
      def initialize(client_id, redirect_uri, **options)
        @client_id = client_id
        @redirect_uri = redirect_uri
        super(**options)
      end

      # @param [String] state A random string to double-check later.
      # @param [Array<String>] scope The scope to request access to.
      # @param [:temporary, :permanent] duration
      # @return [String] The url to redirect the user to.
      def auth_url(state, scope = ["identity"], duration = :temporary)
        query = {
          response_type: "token",
          client_id: @client_id,
          redirect_uri: @redirect_uri,
          state: state,
          scope: scope.join(","),
          duration: duration
        }

        url = URI.join(auth_endpoint, "/api/v1/authorize")
        url.query = URI.encode_www_form(query)
        url.to_s
      end

      # Authorize using the url fragment.
      # @param [String] fragment The part of the url after the "#".
      # @return [Access] The access given by reddit.
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
