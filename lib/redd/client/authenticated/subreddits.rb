module Redd
  module Client
    class Authenticated
      module Subreddits
        def subscribe(subreddit)
          edit_subscription(:sub, subreddit)
        end

        def unsubscribe(subreddit)
          edit_subscription(:unsub, subreddit)
        end

        def get_subreddits(where = :subscriber, params = {})
          meth = :get
          path =
            if [:popular, :new].include?(where)
              "/subreddits/#{where}.json"
            elsif [:subscriber, :contributor, :moderator].include?(where)
              "/subreddits/mine/#{where}.json"
            end
          object_from_response(meth, path, params)
        end

        private

        def edit_subscription(action, subreddit)
          fullname = extract_fullname(subreddit)

          meth = :post
          path = "/api/subscribe"
          params = {action: action, sr: fullname}

          send(meth, path, params)
        end
      end
    end
  end
end
