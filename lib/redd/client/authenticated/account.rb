module Redd
  module Client
    class Authenticated
      module Accounts
        def me
          meth = :get
          path = "/api/me.json"

          object_from_response(meth, path)
        end
      end
    end
  end
end
