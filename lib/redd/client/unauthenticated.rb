require "faraday"
require "redd/version"
require "redd/rate_limit"
require "redd/response/parse_json"
require "redd/response/raise_error"

module Redd
  module Client
    # The Client used to connect without needing login credentials.
    class Unauthenticated
      require "redd/client/unauthenticated/account"
      require "redd/client/unauthenticated/captcha"
      require "redd/client/unauthenticated/links_comments"
      require "redd/client/unauthenticated/listing"
      require "redd/client/unauthenticated/live"
      require "redd/client/unauthenticated/moderation"
      require "redd/client/unauthenticated/subreddits"
      require "redd/client/unauthenticated/utilities"
      require "redd/client/unauthenticated/wiki"

      include Redd::Client::Unauthenticated::Account
      include Redd::Client::Unauthenticated::Captcha
      include Redd::Client::Unauthenticated::LinksComments
      include Redd::Client::Unauthenticated::Listing
      include Redd::Client::Unauthenticated::Live
      include Redd::Client::Unauthenticated::Moderation
      include Redd::Client::Unauthenticated::Subreddits
      include Redd::Client::Unauthenticated::Utilities
      include Redd::Client::Unauthenticated::Wiki

      # @!attribute [r] api_endpoint
      # @return [String] The site to connect to.
      attr_accessor :api_endpoint

      # @!attribute [r] user_agent
      # @return [String] The user-agent used to communicate with reddit.
      attr_accessor :user_agent

      # @!attribute [r] rate_limit
      # @return [#after_limit] The handler that takes care of rate limiting.
      attr_accessor :rate_limit

      # Set up an unauthenticated connection to reddit.
      #
      # @param [Hash] options A hash of options to connect using.
      # @option options [#after_limit] :rate_limit The handler that takes care
      #   of rate limiting.
      # @option options [String] :user_agent The User-Agent string to use in the
      #   header of every request.
      # @option options [String] :api_endpoint The main domain to connect
      #   to, in this case, the URL for reddit.
      def initialize(options = {})
        @rate_limit = options[:rate_limit] || Redd::RateLimit.new
        @user_agent = options[:user_agent] || "Redd/Ruby, v#{Redd::VERSION}"
        @api_endpoint = options[:api_endpoint] || "https://www.reddit.com/"
      end

      private

      # @return [Hash] The headers that are sent with every request.
      def headers
        @headers ||= {"User-Agent" => @user_agent}
      end

      # Gets the Faraday connection or creates one if it doesn't exist yet.
      #
      # @return [Faraday] A new Faraday connection.
      def connection
        @connection ||= Faraday.new(url: api_endpoint) do |faraday|
          faraday.use Faraday::Request::UrlEncoded
          faraday.use Redd::Response::RaiseError
          faraday.use Redd::Response::ParseJson
          faraday.adapter Faraday.default_adapter

          faraday.headers = headers
        end
      end

      # Send a request to the given path.
      #
      # @param [#to_sym] method The HTTP verb to use.
      # @param [String] path The path under the api endpoint to request from.
      # @param [Hash] params The additional parameters to send (defualt: {}).
      # @return [String] The response body.
      def request(method, path, params = {})
        rate_limit.after_limit do
          connection.send(method.to_sym, path, params).body
        end
      end

      # Performs a GET request via {#request}.
      # @see #request
      def get(*args)
        request(:get, *args)
      end

      # Performs a POST request via {#request}.
      # @see #request
      def post(*args)
        request(:post, *args)
      end

      # Performs a PUT request via {#request}.
      # @see #request
      def put(*args)
        request(:put, *args)
      end

      # Performs a DELETE request via {#request}.
      # @see #request
      def delete(*args)
        request(:delete, *args)
      end
    end
  end
end
