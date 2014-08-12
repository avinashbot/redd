require "redd/client/authenticated"

module Redd
  module Client
    # The client to connect using OAuth2.
    class OAuth2 < Redd::Client::Authenticated
      require "redd/client/oauth2/authorization"
      require "redd/client/oauth2/identity"

      include Redd::Client::OAuth2::Authorization
      include Redd::Client::OAuth2::Identity

      # @!attribute [r] auth_endpoint
      # @return [String] The site to connect to authenticate with.
      attr_accessor :auth_endpoint

      # @!attribute [r] client_id
      # @return [String] The client_id of the oauth application.
      attr_reader :client_id

      # @!attribute [r] redirect_uri
      # @return [String] The exact redirect_uri of the oauth application.
      attr_reader :redirect_uri

      # @!attribute [rw] access
      # @return [String] The access info used to make requests.
      attr_accessor :access

      def initialize(client_id, secret, redirect_uri, options = {})
        @client_id = client_id
        @secret = secret
        @redirect_uri = redirect_uri

        @rate_limit = options[:rate_limit] || Redd::RateLimit.new(1)
        @api_endpoint = options[:api_endpoint] || "https://oauth.reddit.com/"
        @auth_endpoint = options[:auth_endpoint] || "https://ssl.reddit.com/"
      end

      def with_access(access)
        new_instance = dup
        new_instance.access = access
        yield new_instance
      end

      private

      def connection
        @connection ||= Faraday.new(url: api_endpoint) do |faraday|
          faraday.use Faraday::Request::UrlEncoded
          faraday.use Redd::Response::RaiseError
          faraday.use Redd::Response::ParseJson
          faraday.adapter Faraday.default_adapter

          faraday.headers["Authorization"] = "bearer #{@access.access_token}"
          faraday.headers["User-Agent"] = "Redd/Ruby, v#{Redd::VERSION}"
        end
      end

      def auth_connection
        @auth_connection ||= Faraday.new(url: auth_endpoint) do |faraday|
          faraday.use Faraday::Request::UrlEncoded
          faraday.use Redd::Response::RaiseError
          faraday.use Redd::Response::ParseJson
          faraday.adapter Faraday.default_adapter

          faraday.basic_auth(@client_id, @secret)
        end
      end
    end
  end
end
