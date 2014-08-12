module Redd
  module Client
    class Authenticated
      # Methods to manage the logged-in user
      module Account
        # @return [Redd::Object::User] The logged-in user.
        def me
          object_from_response :get, "/api/me.json"
        end
      end
    end
  end
end
