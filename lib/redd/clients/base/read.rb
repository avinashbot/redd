module Redd
  module Clients
    class Base
      # Methods that require the "read" scope
      module Read
        # @param [Array<String>] fnames A list of fullnames.
        # @return [Objects::Listing<Objects::Thing>] A listing of things with
        #   the fullname.
        def from_fullname(*fnames)
          names = fnames.join(",")
          request_object(:get, "/api/info", id: names)
        end

        # @param [String] url The url of the thing.
        # @return [Objects::Thing] The thing.
        def from_url(url)
          request_object(:get, "/api/info", url: url).first
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

        # @!method get_hot(subreddit = nil, **params)
        # @!method get_new(subreddit = nil, **params)
        # @!method get_top(subreddit = nil, **params)
        # @!method get_controversial(subreddit = nil, **params)
        # @!method get_comments(subreddit = nil, **params)
        #
        # Get the appropriate listing.
        # @param subreddit [Objects::Subreddit, String] The subreddit to query.
        # @param params [Hash] A list of params to send with the request.
        # @option params [String] :after Return results after the given
        #   fullname.
        # @option params [String :before Return results before the given
        #   fullname.
        # @option params [Integer] :count The number of items already seen in
        #   the listing.
        # @option params [1..100] :limit The maximum number of things to
        #   return.
        # @option params [:hour, :day, :week, :month, :year, :all] :t The
        #   time period to consider when sorting.
        #
        # @note The option :t only applies to the top and controversial sorts.
        # @return [Objects::Listing<Objects::Thing>]
        # @todo Move all listing methods into a helper?
        %w(hot new top controversial comments).each do |sort|
          define_method :"get_#{sort}" do |subreddit = nil, **params|
            srname = property(subreddit, :display_name) if subreddit
            path = "/#{sort}.json"
            path = path.prepend("/r/#{srname}") if subreddit
            request_object(:get, path, params)
          end
        end

        # Search.
        # @param query [String] The query string.
        # @param subreddit [Objects::Subreddit, String] The subreddit to query.
        # @param params [Hash] A list of params to send with the request.
        # @option params [String] :after Return results after the given
        #   fullname.
        # @option params [String :before Return results before the given
        #   fullname.
        # @option params [Integer] :count The number of items already seen in
        #   the listing.
        # @option params [1..100] :limit The maximum number of things to
        #   return.
        # @option params [:cloudsearch, :lucene, :plain] :syntax The type of
        #   syntax to use.
        # @option params [:relevance, :new, :hot, :top, :comments] :sort The
        #   way to sort the results.
        # @option params [:hour, :day, :week, :month, :year, :all] :t The
        #   time period to consider when sorting.
        #
        # @note The option :t only applies to the top and controversial sorts.
        # @return [Objects::Listing<Objects::Thing>]
        def search(query, subreddit = nil, **params)
          path = "/search.json"
          params[:q] = query
          if subreddit
            params[:restrict_sr] = true
            srname = property(subreddit, :display_name)
            path = path.prepend("/r/#{srname}")
          end

          request_object(:get, path, params)
        end

        # Fetch a list of multis belonging to the user.
        def my_multis
          multis = get("/api/multi/mine").body
          multis.map { |thing| object_from_body(thing) }
        end
      end
    end
  end
end
