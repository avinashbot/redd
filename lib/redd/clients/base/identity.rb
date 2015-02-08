module Redd
  module Clients
    class Base
      module Identity
        def me
          response = get("/api/v1/me")
          object_from_body(kind: "t2", data: response.body)
        end

        def my_prefs
          response = get("/api/v1/me/prefs")
          # Basically an uneditable mashie.
          Objects::Base.new(self, response.body)
        end
      end
    end
  end
end
