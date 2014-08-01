module Redd
  module Client
    class Unauthenticated
      module Subreddits
        def subreddit(title)
          meth = :get
          path = "/r/#{title}/about.json"
          object_from_response(meth, path)
        end

        def get_subreddits(where = :popular, params = {})
          meth = :get
          path = "/subreddits/#{where}.json"
          object_from_response(meth, path, params)
        end

        def search_subreddits(query, params = {})
          meth = :get
          path = "/subreddits/search.json"
          params << {q: query}

          object_from_response(meth, path, params)
        end
      end
    end
  end
end
