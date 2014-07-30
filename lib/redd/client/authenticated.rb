module Redd
  module Client
    # The class that handles requests when authenticated using a username and
    # password.
    class Authenticated < Redd::Client::Unauthenticated
      require "redd/client/authenticated/account"
      require "redd/client/authenticated/apps"
      require "redd/client/authenticated/flair"
      require "redd/client/authenticated/gold"
      require "redd/client/authenticated/links_comments"
      require "redd/client/authenticated/live"
      require "redd/client/authenticated/moderation"
      require "redd/client/authenticated/multis"
      require "redd/client/authenticated/private_messages"
      require "redd/client/authenticated/subreddits"
      require "redd/client/authenticated/users"
      require "redd/client/authenticated/wiki"

      include Redd::Client::Authenticated::Account
      include Redd::Client::Authenticated::Apps
      include Redd::Client::Authenticated::Flair
      include Redd::Client::Authenticated::Gold
      include Redd::Client::Authenticated::LinksComments
      include Redd::Client::Authenticated::Live
      include Redd::Client::Authenticated::Moderation
      include Redd::Client::Authenticated::Multis
      include Redd::Client::Authenticated::PrivateMessages
      include Redd::Client::Authenticated::Subreddits
      include Redd::Client::Authenticated::Users
      include Redd::Client::Authenticated::Wiki

      # @!attribute [r] username
      # 	@return [String] The username of the logged-in user.
      attr_reader :username

      # @!attribute [r] cookie
      # 	@return [String] The cookie used to store the current session.
      attr_reader :cookie

      # @!attribute [r] modhash
      # 	@return [String] The returned modhash used when making requests.
      attr_reader :modhash

      # @!attribute [rw] auth_endpoint
      #   @return [String] The site to connect to authenticate with.
      attr_accessor :auth_endpoint

      # Set up an authenticated connection to reddit.
      #
      # @param [String] cookie The cookie to use when sending a request.
      # @param [String] modhash The modhash to use when sending a request.
      # @param [Hash] options A hash of options to connect using.
      # @option options [String] :user_agent The User-Agent string to use in the
      #   header of every request.
      # @option options [String] :api_endpoint The main domain to connect to, in
      #   this case, the URL for reddit.
      # @option options [String] :auth_endpoint The domain to login with, in
      #   this case, the ssl subdomain using https.
      def initialize(cookie, modhash, options = {})
        @cookie = cookie
        @modhash = modhash

        @rate_limit = options[:rate_limit] || Redd::RateLimit.new
        @user_agent = options[:user_agent] || "Redd/Ruby, v#{Redd::VERSION}"
        @api_endpoint = options[:api_endpoint] || "http://www.reddit.com/"
        @auth_endpoint = options[:auth_endpoint] || "https://ssl.reddit.com/"
      end

      private

      # Gets the Faraday connection or creates one if it doesn't exist yet.
      #
      # @return [Faraday] A new Faraday connection.
      def connection
        @connection ||= Faraday.new(url: api_endpoint) do |faraday|
          faraday.use Faraday::Request::UrlEncoded
          faraday.use Redd::Response::ParseJson
          faraday.use Redd::Response::RaiseError
          faraday.adapter Faraday.default_adapter

          faraday.headers["User-Agent"] = user_agent
          faraday.headers["Cookie"] = "reddit_session=#{cookie}"
          faraday.headers["X-Modhash"] = modhash
        end
      end
    end
  end
end
