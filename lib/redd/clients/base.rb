require "faraday"
require_relative "../version"
require_relative "../response/raise_error"
require_relative "../response/parse_json"
require_relative "../rate_limit"
require_relative "../access"

module Redd
  module Clients
    # The basic client to inherit from. Don't use this directly, prefer
    # {Redd.it}
    class Base
      %w(
        utilities
        account
        identity
        privatemessages
        submit
        read
        wikiread
      ).each do |mixin_name|
        require_relative "base/#{mixin_name}"
        camel_case = mixin_name.split("_").map(&:capitalize).join
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

      # Create a Client.
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
      # @note HTTPS is mandatory for OAuth2.
      def initialize(**options)
        @user_agent = options[:user_agent] || "Redd/Ruby, v#{Redd::VERSION}"
        @rate_limit = options[:rate_limit] || RateLimit.new(1)
        @auth_endpoint = options[:auth_endpoint] || "https://www.reddit.com/"
        @api_endpoint = options[:api_endpoint] || "https://oauth.reddit.com/"
        @access = Access.new(expires_at: Time.at(0))
      end

      # @!method get(path, params = {})
      # @!method post(path, params = {})
      # @!method put(path, params = {})
      # @!method patch(path, params = {})
      # @!method delete(path, params = {})
      #
      # Sends the request to the given path with the given params and return
      # the body of the response.
      # @param [String] path The path under the api_endpoint to request.
      # @param [Hash] params The parameters to send with the request.
      # @return [Faraday::Response] The response.
      [:get, :post, :put, :patch, :delete].each do |meth|
        define_method(meth) do |path, params = {}|
          @rate_limit.after_limit do
            final_params = default_params.merge(params)
            connection.send(meth, path, final_params)
          end
        end
      end

      # @param [Access] access The access to use.
      # @yield The client with the given access.
      def with(access)
        new_instance = dup
        new_instance.access = access
        yield new_instance
      end

      # @return [String] The url to redirect the user to for permissions.
      def auth_url
        fail NotImplementedError, "Try Redd.it(...)"
      end

      # Contact reddit and gain access to their API
      # @return [Access] The access given by reddit.
      # @note The returned access is automatically set as the current one.
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

      # @return [Hash] A hash of the headers used.
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
