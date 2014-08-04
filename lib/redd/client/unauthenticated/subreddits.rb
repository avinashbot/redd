module Redd
  module Client
    class Unauthenticated
      module Subreddits
        def subreddit(title)
          object_from_response :get, "/r/#{title}/about.json"
        end

        def get_subreddits(where = :popular, params = {})
          object_from_response :get, "/subreddits/#{where}.json", params
        end

        def search_subreddits(query, params = {})
          params << {q: query}
          object_from_response :get, "/subreddits/search.json", params
        end
      end
    end
  end
end
