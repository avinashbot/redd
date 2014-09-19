require "redd/client/oauth2"

module Redd
  module Client
    class OAuth2Script < Redd::Client::OAuth2
      require "redd/client/oauth2_script/authorization"

      include Redd::Client::OAuth2Script::Authorization

      attr_reader :username

      def initialize(client_id, secret, username, password, options = {})
        @client_id = client_id
        @secret = secret
        @username = username
        @password = password

        @rate_limit = options[:rate_limit] || Redd::RateLimit.new(1)
        @api_endpoint = options[:api_endpoint] || "https://oauth.reddit.com/"
        @auth_endpoint = options[:auth_endpoint] || "https://ssl.reddit.com/"
      end
    end
  end
end
