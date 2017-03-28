# frozen_string_literal: true

require 'rack'
require 'securerandom'

require_relative '../redd'

module Redd
  # Rack middleware.
  # TODO: deal with setting the correct expiry time on the access
  class Middleware
    # @param opts [Hash] the options to create the object with
    # @option opts [String] :user_agent your app's *unique* and *descriptive* user agent
    # @option opts [String] :client_id the client id of your app
    # @option opts [String] :redirect_uri the provided redirect URI
    # @option opts [String] :secret ('') the app secret (for the web type)
    # @option opts [Array<String>] :scope (['identity']) a list of scopes to request
    # @option opts ['temporary', 'permanent'] :duration ('permanent') the duration to request the
    #   code for.
    # @option opts [String] :via ('/auth/reddit') the relative path in the application that
    #   redirects a user to reddit
    def initialize(app, opts = {})
      @app = app
      strategy_opts = opts.select { |k| %i(user_agent client_id secret redirect_uri).include?(k) }
      @strategy = Redd::AuthStrategies::Web.new(strategy_opts)

      @user_agent   = opts.fetch(:user_agent, "Redd:Web Application:v#{Redd::VERSION} (by unknown)")
      @client_id    = opts.fetch(:client_id)
      @redirect_uri = opts.fetch(:redirect_uri)
      @scope        = opts.fetch(:scope, ['identity'])
      @duration     = opts.fetch(:duration, 'permanent')
      @via          = opts.fetch(:via, '/auth/reddit')
    end

    def call(env)
      # This is done for thread safety so that each thread has its own copy
      # of the middleware logic.
      dup._call(env)
    end

    protected

    def _call(env)
      @request = Rack::Request.new(env)
      return redirect_to_reddit! if @request.path == @via

      before_call
      response = @app.call(env)
      after_call

      response
    end

    private

    # Do any setup before calling the rest of the application.
    def before_call
      # Convert the code to an access token if returning from authentication.
      create_session! if @request.base_url + @request.path == @redirect_uri
      # Clear the state for any other request.
      @request.session.delete(:redd_state)
      # Load a Session model from the access token in the user's cookies.
      @request.env['redd.session'] = parse_session
    end

    # Do any cleanup or changes after calling the application.
    def after_call
      # Clear the session if the app explicitly set 'redd.session' to nil.
      # XXX: does this seem like a good approach?
      @request.session.delete(:redd_session) if @request.env['redd.session'].nil?
    end

    # Creates a unique state and redirects the user to reddit for authentication.
    def redirect_to_reddit!
      state = SecureRandom.urlsafe_base64
      url = Redd.url(
        client_id: @client_id,
        redirect_uri: @redirect_uri,
        scope: @scope,
        duration: @duration,
        state: state
      )
      @request.session[:redd_state] = state
      [302, { 'Location' => url }, []]
    end

    # Assigns a single string representing a reddit authentication errors.
    # TODO: would be preferable if we assigned an exception object instead...
    def handle_error
      return 'invalid_state' if @request.GET['state'] != @request.session[:redd_state]
      return @request.GET['error'] if @request.GET['error']
      nil
    end

    # Store the access token and other details in the user's browser.
    def create_session!
      # Skip authorizing if there was an error from the authorization.
      @request.env['redd.error'] = handle_error
      if @request.env['redd.error']
        @request.session.delete(:redd_session)
        return
      end

      # Try to get a code (the rescue block will also prevent crazy crashes)
      access = @strategy.authenticate(@request.GET['code'])
      @request.session[:redd_session] = { token: access.to_h, authorized_at: Time.now.to_i }
    rescue Redd::ResponseError => e
      @request.env['redd.error'] = e
    end

    # Return a {Redd::Models::Session} based on the hash saved into the browser's session.
    def parse_session
      return nil unless @request.session[:redd_session]
      client = Redd::APIClient.new(@strategy, user_agent: @user_agent, limit_time: 0)
      client.access = Redd::Models::Access.new(@strategy, @request.session[:redd_session][:token])
      Redd::Models::Session.new(client)
    end
  end
end
