module Redd
  module Clients
    class Base
      module Read
        def user_from_name(name)
          request_object(:get, "/user/#{name}/about.json")
        end

        def subreddit_from_name(name)
          request_object(:get, "/r/#{name}/about.json")
        end
      end
    end
  end
end
