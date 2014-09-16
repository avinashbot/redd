module Redd
  module Client
    class Unauthenticated
      # Methods that deal with subreddits
      module Subreddits
        # Return a Subreddit object from the title of a subreddit.
        # @param title [String] The name of the subreddit.
        # @return [Redd::Object::Subreddit]
        def subreddit(title)
          object_from_response :get, "/r/#{title}/about.json"
        end

        # Get a list of subreddits sorted by the given parameter.
        # @param where [:popular, :new] The type of subreddits to look for.
        # @param params [Hash] A hash of parameters to send with the request.
        # @option params [String] :after Return results after the given
        #   fullname.
        # @option params [String] :before Return results before the given
        #   fullname.
        # @option params [Integer] :count (0) The number of items already seen
        #   in the listing.
        # @option params [1..100] :limit (25) The maximum number of things to
        #   return.
        # @return [Redd::Object::Listing] A listing of subreddits.
        def get_subreddits(where = :popular, params = {})
          object_from_response :get, "/subreddits/#{where}.json", params
        end

        # Look for subreddits matching the given query.
        #
        # @param query [String] The search query.
        # @param params [Hash] A hash of parameters to send with the request.
        # @option params [String] :after Return results after the given
        #   fullname.
        # @option params [String] :before Return results before the given
        #   fullname.
        # @option params [Integer] :count (0) The number of items already seen
        #   in the listing.
        # @option params [1..100] :limit (25) The maximum number of things to
        #   return.
        # @return [Redd::Object::Listing] A listing of subreddits.
        def search_subreddits(query, params = {})
          params << {q: query}
          object_from_response :get, "/subreddits/search.json", params
        end
      end
    end
  end
end
