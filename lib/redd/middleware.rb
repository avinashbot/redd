# frozen_string_literal: true

require 'rack'
require 'securerandom'

require_relative '../redd'

module Redd
  # Rack middleware.
  # TODO: verify state
  # TODO: deal with error from reddit
  # TODO: deal with access_denied
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
      dup.thread_unsafe_call(env)
    end

    protected

    def thread_unsafe_call(env)
      @request = Rack::Request.new(env)

      # Redirect user to reddit for authentication.
      return redirect_to_reddit! if @request.path == @via
      # Convert the code to an access token if returning from authentication.
      create_session! if @request.base_url + @request.path == @redirect_uri
      # Clear the state for any other request.
      @request.session[:redd_state] = nil
      # Load a Session model from the access token in the user's cookies.
      @request.env['redd.session'] = parse_session
      # Go through the rest of the app.
      @app.call(env)
    end

    private

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
      [302, { 'Location' => url, 'Content-Type' => 'text/html' }, ["<a href=\"#{url}\">Login</a>"]]
    end

    def handle_error
      return 'invalid_state' if @request.GET['state'] != @request.session[:redd_state]
      return @request.GET['error'] if @request.GET['error']
      nil
    end

    def create_session!
      @request.env['redd.error'] = handle_error
      if @request.env['redd.error']
        @request.session[:redd_session] = nil
        return
      end
      access = @strategy.authenticate(@request.GET['code'])
      @request.session[:redd_session] = { token: access.to_h, authorized_at: Time.now.to_i }
    rescue Redd::ResponseError => e
      @request.env['redd.error'] = e
    end

    def parse_session
      return nil unless @request.session[:redd_session]
      client = Redd::APIClient.new(@strategy, user_agent: @user_agent, limit_time: 0)
      client.access = Redd::Models::Access.new(@strategy, @request.session[:redd_session][:token])
      Redd::Models::Session.new(client)
    end
  end
end
