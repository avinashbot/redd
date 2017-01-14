# frozen_string_literal: true

require 'uri'

# Redd Version
require_relative 'redd/version'
# Models
Dir[File.join(__dir__, 'redd', 'models', '*.rb')].each { |f| require f }
# Authentication Clients
Dir[File.join(__dir__, 'redd', 'auth_strategies', '*.rb')].each { |f| require f }
# Regular Client
require_relative 'redd/api_client'

# Redd is a simple and intuitive API wrapper.
module Redd
  class << self
    # Guesses the appropriate authentication strategy, creates an API client and starts you off with
    # a {Models::Session}.
    # @see https://www.reddit.com/prefs/apps
    # @param opts [Hash] the options to create the object with
    # @option opts [String] :user_agent your app's *unique* and *descriptive* user agent
    # @option opts [String] :client_id the client id of your app
    # @option opts [String] :secret the app secret (for confidential types, i.e. *not* *installed*)
    # @option opts [String] :username the username of your bot (only for *script*)
    # @option opts [String] :password the plaintext password of your bot (only for *script*)
    # @option opts [String] :redirect_uri the provided redirect URI (only for *web* and *installed*)
    # @option opts [String] :code the code given by reddit (required for *web* and *installed*)
    # @return [Models::Session] a fresh {Models::Session} for you to make requests with
    def it(opts = {})
      api_client = script(opts) || web(opts) || installed(opts) || userless(opts)
      raise "couldn't guess app type" unless api_client
      Models::Session.new(api_client) { |client| client.get('/api/v1/me').body }
    end

    # Create a url to send to users for authorization.
    # @param response_type ['code', 'token'] the type of response from reddit
    # @param state [String] a randomly generated token to avoid CSRF attacks.
    # @param client_id [String] the client id of the app
    # @param redirect_uri [String] the URI for reddit to redirect to after authorization
    # @param scope [Array<String>] an array of scopes to request
    # @return [String] the generated url
    def url(response_type: 'code', state: '0', scope: ['identity'], client_id:, redirect_uri:)
      'https://www.reddit.com/api/v1/authorize?' + URI.encode_www_form(
        client_id: client_id,
        redirect_uri: redirect_uri,
        state: state,
        scope: scope.join(','),
        response_type: response_type
      )
    end

    private

    def filter_auth(opts)
      opts.select { |k| %i(client_id secret username password redirect_uri user_agent).include?(k) }
    end

    def filter_api(opts)
      opts.select { |k| %i(user_agent).include?(k) }
    end

    def script(opts = {})
      return unless %i(client_id secret username password).all? { |o| opts.include?(o) }
      api = APIClient.new(AuthStrategies::Script.new(**filter_auth(opts)), **filter_api(opts))
      api.tap(&:authenticate)
    end

    def web(opts = {})
      return unless %i(client_id secret redirect_uri code).all? { |o| opts.include?(o) }
      code = opts.delete(:code)
      api = APIClient.new(AuthStrategies::Web.new(**filter_auth(opts)), **filter_api(opts))
      api.tap { |c| c.authenticate(code) }
    end

    def installed(opts = {})
      return unless %i(client_id redirect_uri code).all? { |o| opts.include?(o) }
      code = opts.delete(:code)
      api = APIClient.new(AuthStrategies::Installed.new(**filter_auth(opts)), **filter_api(opts))
      api.tap { |c| c.authenticate(code) }
    end

    def userless(opts = {})
      return unless %i(client_id secret).all? { |o| opts.include?(o) }
      api = APIClient.new(AuthStrategies::Userless.new(**filter_auth(opts)), **filter_api(opts))
      api.tap(&:authenticate)
    end
  end
end
