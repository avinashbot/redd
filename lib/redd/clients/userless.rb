require_relative "base"

module Redd
  module Clients
    # The client that doesn't need a user to function.
    # @note Of course, that means many editing methods throw an error.
    class Userless < Base
      # @!attribute [r] client_id
      attr_reader :client_id

      # @param [Hash] options The options to create the client with.
      # @see Redd.it
      def initialize(client_id, secret, **options)
        @client_id = client_id
        @secret = secret
        super(**options)
      end

      # Authorize using the given data.
      # @return [Access] The access given by reddit.
      def authorize!
        response = auth_connection.post(
          "/api/v1/access_token",
          grant_type: "client_credentials"
        )

        @access = Access.new(response.body)
      end
    end
  end
end
