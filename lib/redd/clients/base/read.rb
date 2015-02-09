module Redd
  module Clients
    class Base
      module Read
        # @param [Array<String>] fnames A list of fullnames.
        # @return [Objects::Listing<Objects::Thing>] A listing of things with
        #   the fullname.
        def from_id(*fnames)
          names = fnames.join(",")
          request_object(:get, "/by_id/#{names}")
        end

        # @param [String] name The username.
        # @return [Objects::User] The user.
        def user_from_name(name)
          request_object(:get, "/user/#{name}/about.json")
        end

        # @param [String] name The subreddit's display name.
        # @return [Objects::Subreddit] The subreddit if found.
        def subreddit_from_name(name)
          request_object(:get, "/r/#{name}/about.json")
        end

        # @!method get_hot(subreddit = nil, params = {})
        # @!method get_new(subreddit = nil, params = {})
        # @!method get_top(subreddit = nil, params = {})
        # @!method get_controversial(subreddit = nil, params = {})
        # @!method get_comments(subreddit = nil, params = {})
        #
        # Get the appropriate listing.
        # @param subreddit [Objects::Subreddit, String] The subreddit to query.
        # @param params [Hash] A list of params to send with the request.
        # @option params [String] :after Return results after the given
        #   fullname.
        # @option params [String] :before Return results before the given
        #   fullname.
        # @option params [Integer] :count (0) The number of items already seen
        #   in the listing.
        # @option params [1..100] :limit (25) The maximum number of things to
        #   return.
        # @option params [:hour, :day, :week, :month, :year, :all] :t The
        #   time period to consider when sorting.
        #
        # @note The option :t only applies to the top and controversial sorts.
        # @return [Objects::Listing<Objects::Thing>]
        %w(hot new top controversial comments).each do |sort|
          define_method :"get_#{sort}" do |subreddit = nil, **params|
            srname = property(subreddit, :display_name) if subreddit
            path = "/#{sort}.json"
            path = path.prepend("/r/#{srname}") if subreddit
            request_object(:get, path, params)
          end
        end
      end
    end
  end
end
