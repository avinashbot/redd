module Redd
  module Client
    class Unauthenticated
      module Moderation
        def stylesheet_url(subreddit = nil)
          meth = :get
          path = "/stylesheet"
          path = path.prepend("/r/#{subreddit}") if subreddit

          send(meth, path).headers[:location]
        end

        def stylesheet(subreddit = nil)
          meth = :get
          path = stylesheet_url(subreddit)
          send(meth, path).body
        end
      end
    end
  end
end
