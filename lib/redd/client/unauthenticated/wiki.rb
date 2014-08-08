module Redd
  module Client
    class Unauthenticated
      module Wiki
        def get_wikipages(subreddit = nil)
          path = "/wiki/pages.json"
          path.prepend("/r/#{subreddit}") if subreddit
          get(path)[:data]
        end

        def wikipage(page, subreddit = nil, params = {})
          path = "/wiki/#{page}.json"
          path.prepend("/r/#{subreddit}") if subreddit
          get path, params
        end
      end
    end
  end
end
