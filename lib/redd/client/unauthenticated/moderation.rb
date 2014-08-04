module Redd
  module Client
    class Unauthenticated
      module Moderation
        def stylesheet_url(subreddit = nil)
          path = "/stylesheet"
          path = path.prepend("/r/#{subreddit}") if subreddit

          get(path).headers[:location]
        end

        def stylesheet(subreddit = nil)
          get stylesheet_url(subreddit)
        end
      end
    end
  end
end
