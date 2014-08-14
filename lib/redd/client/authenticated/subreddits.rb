module Redd
  module Client
    class Authenticated
      # Methods to interact with subreddits
      module Subreddits
        # Subscribe to a subreddit.
        #
        # @param subreddit [Redd::Object::Subreddit, String] The subreddit to
        #   subscribe to.
        def subscribe(subreddit)
          edit_subscription(:sub, subreddit)
        end

        # Unsubscribe from a subreddit.
        #
        # @param subreddit [Redd::Object::Subreddit, String] The subreddit to
        #   unsubscribe from.
        def unsubscribe(subreddit)
          edit_subscription(:unsub, subreddit)
        end

        # Get a listing of subreddits.
        #
        # @param where [:popular, :new, :subscriber, :contributor, :moderator]
        #   The order of subreddits to return.
        # @param params [Hash] A list of params to send with the request.
        # @option params [String] :after Return results after the given
        #   fullname.
        # @option params [String] :before Return results before the given
        #   fullname.
        # @option params [Integer] :count (0) The number of items already seen
        #   in the listing.
        # @option params [1..100] :limit (25) The maximum number of things to
        #   return.
        # @return [Redd::Object::Listing] A listing of subreddits.
        def get_subreddits(where = :subscriber, params = {})
          path =
            if [:popular, :new].include?(where)
              "/subreddits/#{where}.json"
            elsif [:subscriber, :contributor, :moderator].include?(where)
              "/subreddits/mine/#{where}.json"
            end
          object_from_response(:get, path, params)
        end

        private

        # Subscribe or unsubscribe to a subreddit.
        #
        # @param action [:sub, :unsub] The type of action to perform.
        # @param subreddit [Redd::Object::Subreddit, String] The subreddit to
        #   perform the action on.
        def edit_subscription(action, subreddit)
          fullname = extract_fullname(subreddit)
          post "/api/subscribe", action: action, sr: fullname
        end
      end
    end
  end
end
