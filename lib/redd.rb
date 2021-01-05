# frozen_string_literal: true

require 'uri'

# Redd Version
require_relative 'redd/version'
# Models
Dir[File.join(__dir__, 'redd', 'models', '*.rb')].each { |f| require f }
# Authentication Clients
Dir[File.join(__dir__, 'redd', 'auth_strategies', '*.rb')].each { |f| require f }
# Error Classes
require_relative 'redd/errors'
# Regular Client
require_relative 'redd/api_client'
# Assists
Dir[File.join(__dir__, 'redd', 'assist', '*.rb')].each { |f| require f }

# Redd is a simple and intuitive API wrapper.
module Redd
  class << self
    # Based on the arguments you provide it, it guesses the appropriate authentication strategy.
    # You can do this manually with:
    #
    #     script   = Redd::AuthStrategies::Script.new(**arguments)
    #     web      = Redd::AuthStrategies::Web.new(**arguments)
    #     userless = Redd::AuthStrategies::Userless.new(**arguments)
    #
    # It then creates an {APIClient} with the auth strategy provided and calls authenticate on it:
    #
    #     client = Redd::APIClient.new(script); client.authenticate(code)
    #     client = Redd::APIClient.new(web); client.authenticate
    #     client = Redd::APIClient.new(userless); client.authenticate
    #
    # Finally, it creates the {Models::Session} model, which is essentially a starting point for
    # the user. But you can basically create any model with the client.
    #
    #     session = Redd::Models::Session.new(client)
    #
    #     user = Redd::Models::User.new(client, name: 'Mustermind')
    #     puts user.comment_karma
    #
    # If `auto_refresh` is `false` or if the access doesn't have an associated `expires_in`, you
    # can manually refresh the token by calling:
    #
    #     session.client.refresh
    #
    # Also, you can swap out the client's access any time.
    #
    #     new_access = { access_token: '', refresh_token: '', expires_in: 1234 }
    #
    #     session.client.access = Redd::Models::Access.new(script, new_access)
    #     session.client.access = Redd::Models::Access.new(web, new_access)
    #     session.client.access = Redd::Models::Access.new(userless, new_access)
    #
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
      api_client = script(opts) || web(opts) || userless(opts)
      raise "couldn't guess app type" unless api_client
      Models::Session.new(api_client)
    end

    # Create a url to send to users for authorization.
    # @param response_type ['code', 'token'] the type of response from reddit
    # @param state [String] a randomly generated token to avoid CSRF attacks.
    # @param client_id [String] the client id of the app
    # @param redirect_uri [String] the URI for reddit to redirect to after authorization
    # @param scope [Array<String>] an array of scopes to request
    # @param duration ['temporary', 'permanent'] the duration to request the code for (only applies
    #   when response_type is 'code')
    # @return [String] the generated url
    def url(client_id:, redirect_uri:, response_type: 'code', state: '', scope: ['identity'],
            duration: 'temporary')
      'https://www.reddit.com/api/v1/authorize?' + URI.encode_www_form(
        client_id: client_id,
        redirect_uri: redirect_uri,
        state: state,
        scope: scope.join(','),
        response_type: response_type,
        duration: duration
      )
    end

    private

    def filter_auth(opts)
      opts.select { |k| %i[client_id secret username password redirect_uri user_agent].include?(k) }
    end

    def filter_api(opts)
      opts.select { |k| %i[user_agent limit_time max_retries auto_refresh].include?(k) }
    end

    def script(opts = {})
      return unless %i[client_id secret username password].all? { |o| opts.include?(o) }
      auth = AuthStrategies::Script.new(**filter_auth(opts))
      api = APIClient.new(auth, **filter_api(opts))
      api.tap(&:authenticate)
    end

    def web(opts = {})
      return unless %i[client_id redirect_uri code].all? { |o| opts.include?(o) }
      auth = AuthStrategies::Web.new(**filter_auth(opts))
      api = APIClient.new(auth, **filter_api(opts))
      api.tap { |c| c.authenticate(opts[:code]) }
    end

    def userless(opts = {})
      return unless %i[client_id secret].all? { |o| opts.include?(o) }
      auth = AuthStrategies::Userless.new(**filter_auth(opts))
      api = APIClient.new(auth, **filter_api(opts))
      api.tap(&:authenticate)
    end
  end
end
