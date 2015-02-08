module Redd
  module Clients
    class Base
      module Account
        def edit_my_prefs(changed_prefs)
          patch("/api/v1/me/prefs", changed_prefs)
        end
      end
    end
  end
end
