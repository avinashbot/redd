module Redd
  module Client
    class Unauthenticated
      # Methods for managing accounts.
      module Account
        # Login to the reddit account.
        #
        # @param username [String] The username.
        # @param password [String] The password.
        # @param remember [Boolean] Indicates whether you intend to use the
        #   returned cookie for a long time.
        # @param options [Hash] The options to create an instance of
        #   {Redd::Client::Authenticated}.
        def login(username, password, remember = false, options = {})
          response = post "/api/login",
                          api_type: "json",
                          user: username,
                          passwd: password,
                          rem: remember
          data = response[:json][:data]

          require "redd/client/authenticated"
          Redd::Client::Authenticated.new(
            data[:cookie], data[:modhash], options
          )
        end
      end
    end
  end
end
