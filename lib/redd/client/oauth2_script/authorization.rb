require "redd/oauth2_access"

module Redd
  module Client
    class OAuth2Script
      # Methods for obtaining an access token
      module Authorization
        def request_access(set_access = true)
          response = auth_connection.post "/api/v1/access_token",
                                          grant_type: "password",
                                          username: @username,
                                          password: @password

          access = Redd::OAuth2Access.new(response.body)
          @access = access if set_access
          access
        end
      end
    end
  end
end
