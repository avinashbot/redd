module Redd
  module Client
    class OAuth2
      # Methods to interact with the user logged-in via OAuth2
      module Identity
        def me
          response = get "/api/v1/me.json"
          object_from_body kind: "t2", data: response
        end
      end
    end
  end
end
