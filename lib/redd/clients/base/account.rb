module Redd
  module Clients
    class Base
      module Account
        def edit_my_prefs(changed_prefs)
          response = connection.patch do |req|
            req.url "/api/v1/me/prefs"
            req.body = MultiJson.dump(changed_prefs)
          end
          
          Objects::Base.new(self, response.body)
        end
      end
    end
  end
end
