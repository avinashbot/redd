module Redd
  module Client
    class OAuth2
      # Methods to interact with the user logged-in via OAuth2
      module Identity
        # @return [Redd::Object::User] The logged-in user.
        # @note This overrides the Authenticated class's method, since that
        #   method doesn't apply here but does the same thing.
        def me
          response = get "/api/v1/me.json"
          object_from_body kind: "t2", data: response
        end
      end
    end
  end
end
