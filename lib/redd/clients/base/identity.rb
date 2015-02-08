module Redd
  module Clients
    class Base
      module Identity
        # @return [Objects::User] The logged-in user.
        def me
          response = get("/api/v1/me")
          object_from_body(kind: "t2", data: response.body)
        end

        # @return [Objects::Base] Your current preferences.
        # @see https://www.reddit.com/dev/api/oauth#GET_api_v1_me_prefs
        def my_prefs
          response = get("/api/v1/me/prefs")
          # Basically an uneditable mashie.
          Objects::Base.new(self, response.body)
        end
      end
    end
  end
end
