module Redd
  module Client
    class Unauthenticated
      module Subreddits
        def subreddit(name)
          meth = :get
          path = "/r/#{name}/about.json"
          object_from_response(meth, path)
        end
      end
    end
  end
end
