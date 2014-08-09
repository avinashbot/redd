require "redd/client/authenticated"

module Redd
  module Client
    # The client to connect using OAuth2.
    class OAuth2 < Redd::Client::Authenticated
      require "redd/client/oauth2/authorization"
      require "redd/client/oauth2/identity"

      include Redd::Client::OAuth2::Authorization
      include Redd::Client::OAuth2::Identity

      # @!attribute [r] api_endpoint
      # @return [String] The site to make oauth requests with.
      attr_accessor :api_endpoint

      # @!attribute [r] auth_endpoint
      # @return [String] The site to connect to authenticate with.
      attr_accessor :auth_endpoint

      # @!attribute [r] client_id
      # @return [String] The client_id of the oauth application.
      attr_reader :client_id

      # @!attribute [r] redirect_uri
      # @return [String] The exact redirect_uri of the oauth application.
      attr_reader :redirect_uri

      # @!attribute [rw] access_token
      # @return [String] The access token used to make requests.
      attr_accessor :access_token

      def initialize(client_id, secret, redirect_uri, options = {})
        @client_id = client_id
        @secret = secret
        @redirect_uri = redirect_uri

        @rate_limit = options[:rate_limit] || Redd::RateLimit.new(1)
        @api_endpoint = options[:api_endpoint] || "https://oauth.reddit.com/"
        @auth_endpoint = options[:auth_endpoint] || "https://ssl.reddit.com/"
      end

      private

      def connection(access_token = @access_token)
        @connection ||= Faraday.new(url: api_endpoint) do |faraday|
          faraday.use Faraday::Request::UrlEncoded
          faraday.use Redd::Response::RaiseError
          faraday.use Redd::Response::ParseJson
          faraday.adapter Faraday.default_adapter

          faraday.headers["Authorization"] = "bearer #{access_token}"
        end
      end

      def auth_connection
        @auth_connection ||= Faraday.new(url: auth_endpoint) do |faraday|
          faraday.use Faraday::Request::UrlEncoded
          faraday.use Redd::Response::ParseJson
          faraday.basic_auth(@client_id, @secret)
          faraday.adapter Faraday.default_adapter
        end
      end

      # @return [Hash] The headers that are sent with every request.
      def headers
        @headers ||= {}
      end
    end
  end
end
