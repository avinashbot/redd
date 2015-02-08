require "faraday"
require_relative "../version"
require_relative "../response/raise_error"
require_relative "../response/parse_json"
require_relative "../rate_limit"
require_relative "../access"

module Redd
  module Clients
    class Base
      %w(
        utilities
        account
        identity
        private_messages
        read
      ).each do |mixin_name|
        camel_case = mixin_name.split("_").map(&:capitalize).join
        require_relative "base/#{mixin_name}"
        include const_get(camel_case)
      end

      # @!attribute [r] user_agent
      # @return [String] The user-agent used to communicate with reddit.
      attr_reader :user_agent

      # @!attribute [r] rate_limit
      # @return [#after_limit] The handler that takes care of rate limiting.
      attr_reader :rate_limit

      # @!attribute [r] auth_endpoint
      # @return [String] The site to connect to for authentication.
      attr_reader :auth_endpoint

      # @!attribute [r] api_endpoint
      # @return [String] The site to make API requests with.
      attr_reader :api_endpoint

      # @!attribute [rw] access
      # @return [Access] The access object to make API requests with.
      attr_accessor :access

      # Set up an unauthenticated connection to reddit.
      #
      # @param [Hash] options The options to create the client with.
      # @param options [String] :user_agent The User-Agent string to use in the
      #   header of every request.
      # @param options [#after_limit] :rate_limit The handler that takes care of
      #   rate limiting.
      # @param options [String] :auth_endpoint The main domain to authenticate
      #   with.
      # @param options [String] :api_endpoint The main domain to make requests
      #   with.
      # @note It's generally a good idea to stick with https.
      def initialize(**options)
        @user_agent = options[:user_agent] || "Redd/Ruby, v#{Redd::VERSION}"
        @rate_limit = options[:rate_limit] || RateLimit.new(1)
        @auth_endpoint = options[:auth_endpoint] || "https://www.reddit.com/"
        @api_endpoint = options[:api_endpoint] || "https://oauth.reddit.com/"
        @access = Access.new(expires_at: Time.at(0))
      end

      # @!method get
      # @!method post
      # @!method put
      # @!method patch
      # @!method delete
      #
      # Sends the request to the given path with the given params and return
      # the body of the response.
      # @param [String] path The path under the api_endpoint to request.
      # @param [Hash] params The parameters to send with the request.
      # @return [String] The response body.
      [:get, :post, :put, :patch, :delete].each do |meth|
        define_method(meth) do |path, params = {}|
          @rate_limit.after_limit do
            final_params = default_params.merge(params)
            connection.send(meth, path, final_params)
          end
        end
      end

      def with(access)
        new_instance = dup
        new_instance.access = access
        yield new_instance
      end

      def auth_url
        fail NotImplementedError, "Try Redd.it(...)"
      end

      def authorize!
        fail NotImplementedError, "Try Redd.it(...)"
      end

      private

      # @return [Faraday::Connection] A new or existing connection.
      def connection
        @connection ||= Faraday.new(
          @api_endpoint,
          headers: default_headers,
          builder: middleware
        )
      end

      # @return [Hash] The minimum parameters to send with every request.
      def default_params
        @default_params ||= {api_type: "json"}
      end

      # @return [Hash] A hash of default headers.
      def default_headers
        {
          "User-Agent" => @user_agent,
          "Authorization" => "bearer #{@access.access_token}"
        }
      end

      # @return [Faraday::RackBuilder] The middleware to use when creating the
      #   connection.
      def middleware
        @middleware ||= Faraday::RackBuilder.new do |builder|
          builder.use Response::RaiseError
          builder.use Response::ParseJson
          builder.use Faraday::Request::UrlEncoded
          builder.adapter Faraday.default_adapter
        end
      end
    end
  end
end
