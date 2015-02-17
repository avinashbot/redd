require "faraday"
require_relative "../version"
require_relative "../response/raise_error"
require_relative "../response/parse_json"
require_relative "../rate_limit"
require_relative "../access"

module Redd
  # The module containing the multiple types of clients.
  module Clients
    # The basic client to inherit from. Don't use this directly, prefer
    # {Redd.it}
    class Base
      # @!parse include Utilities
      # @!parse include Account
      # @!parse include Identity
      # @!parse include None
      # @!parse include Privatemessages
      # @!parse include Read
      # @!parse include Submit
      # @!parse include Stream
      # @!parse include Wikiread
      %w(
        utilities account identity none privatemessages read submit stream
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
      # @option options [String] :user_agent The User-Agent string to use in
      #   the header of every request.
      # @option options [#after_limit] :rate_limit The handler that takes care
      #   of rate limiting.
      # @option options [String] :auth_endpoint The main domain to authenticate
      #   with.
      # @option options [String] :api_endpoint The main domain to make requests
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

      # Obtain a new access token using a refresh token.
      # @return [Access] The refreshed information.
      def refresh_access!
        response = auth_connection.post(
          "/api/v1/access_token",
          grant_type: "refresh_token",
          refresh_token: access.refresh_token
        )
        access.refreshed!(response.body)
      end

      # Dispose of an access or refresh token when you're done with it.
      # @param [Boolean] remove_refresh_token Whether or not to remove all
      #   tokens associated with the user.
      def revoke_access!(remove_refresh_token = false)
        token_type = remove_refresh_token ? :refresh_token : :access_token
        token = access.send(token_type)
        @access = nil
        auth_connection.post(
          "/api/v1/revoke_token",
          token: token,
          token_type_hint: token_type
        )
      end

      private

      # @return [Faraday::RackBuilder] The middleware to use when creating the
      #   connection.
      def middleware
        @middleware ||= Faraday::RackBuilder.new do |builder|
          builder.use Response::RaiseError
          builder.use Response::ParseJson
          builder.use Faraday::Request::Multipart
          builder.use Faraday::Request::UrlEncoded
          builder.adapter Faraday.default_adapter
        end
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

      # @return [Faraday::Connection] A new or existing connection.
      def connection
        @connection ||= Faraday.new(
          @api_endpoint,
          headers: default_headers,
          builder: middleware
        )
      end

      # @return [Hash] A hash of the headers with basic auth.
      def auth_headers
        {
          "User-Agent" => @user_agent,
          "Authorization" => Faraday.basic_auth(@client_id, @secret)
        }
      end

      # @return [Faraday::Connection] A new or existing connection.
      def auth_connection
        @auth_connection ||= Faraday.new(
          @auth_endpoint,
          headers: auth_headers,
          builder: middleware
        )
      end
    end
  end
end
