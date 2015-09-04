require_relative "base"

module Redd
  module Clients
    # The client for an account you own (e.g. bots).
    class Script < Base
      # @!attribute [r] client_id
      attr_reader :client_id

      # @!attribute [r] username
      attr_reader :username

      # @param [Hash] options The options to create the client with.
      # @see Base#initialize
      # @see Redd.it
      def initialize(client_id, secret, username, password, **options)
        @client_id = client_id
        @secret = secret
        @username = username
        @password = password
        super(**options)
      end

      # Authorize using the given data.
      # @return [Access] The access given by reddit.
      def authorize!
        response = auth_connection.post(
          "/api/v1/access_token",
          grant_type: "password",
          username: @username,
          password: @password
        )

        @access = Access.new(response.body)
      end

      alias_method :refresh_access!, :authorize!

    end
  end
end
