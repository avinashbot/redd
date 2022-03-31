# frozen_string_literal: true

require 'http'
require 'json'

module Redd
  # The base class for JSON-based HTTP clients. Generic enough to be used for basically anything.
  class Client
    # The default User-Agent to use if none was provided.
    USER_AGENT = "Ruby:Redd:v#{Redd::VERSION} (by unknown)"

    # Holds a returned HTTP response.
    Response = Struct.new(:code, :headers, :raw_body) do
      def body
        @body ||= JSON.parse(raw_body, symbolize_names: true)
      end
    end

    # Create a new client.
    # @param endpoint [String] the base endpoint to make all requests from
    # @param user_agent [String] a user agent string
    def initialize(endpoint:, user_agent: USER_AGENT)
      @endpoint = endpoint
      @user_agent = user_agent
    end

    # Make an HTTP request.
    # @param verb [:get, :post, :put, :patch, :delete] the HTTP verb to use
    # @param path [String] the path relative to the endpoint
    # @param options [Hash] the request parameters
    # @option options [Hash] :params the parameters to supply with the url
    # @option options [Hash] :form the parameters to supply in the body
    # @option options [Hash] :body the direct body contents
    # @return [Response] the response
    def request(verb, path, options = {})
      # puts "#{verb.to_s.upcase} #{path}", '  ' + options.inspect
      response = connection.request(verb, path, **options)
      Response.new(response.status.code, response.headers, response.body.to_s)
    end

    # Make a GET request.
    # @param path [String] the path relative to the endpoint
    # @param options [Hash] the parameters to supply
    # @return [Response] the response
    def get(path, options = {})
      request(:get, path, params: options)
    end

    # Make a POST request.
    # @param path [String] the path relative to the endpoint
    # @param options [Hash] the parameters to supply
    # @return [Response] the response
    def post(path, options = {})
      request(:post, path, form: options)
    end

    # Make a PUT request.
    # @param path [String] the path relative to the endpoint
    # @param options [Hash] the parameters to supply
    # @return [Response] the response
    def put(path, options = {})
      request(:put, path, form: options)
    end

    # Make a PATCH request.
    # @param path [String] the path relative to the endpoint
    # @param options [Hash] the parameters to supply
    # @return [Response] the response
    def patch(path, options = {})
      request(:patch, path, form: options)
    end

    # Make a DELETE request.
    # @param path [String] the path relative to the endpoint
    # @param options [Hash] the parameters to supply
    # @return [Response] the response
    def delete(path, options = {})
      request(:delete, path, form: options)
    end

    private

    # @return [HTTP::Connection] the base connection object
    def connection
      # TODO: Make timeouts configurable
      @connection ||= HTTP.persistent(@endpoint)
                          .headers('User-Agent' => @user_agent)
                          .timeout(write: 5, connect: 5, read: 5)
    end
  end
end
