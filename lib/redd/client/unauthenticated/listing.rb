module Redd
  module Client
    class Unauthenticated
      # Methods that return a listing
      module Listing
        # Get an object based on its id.
        #
        # @param fullname [String] The fullname of a thing.
        # @return [Redd::Object] The object with the id.
        def by_id(fullname)
          object_from_response :get, "/by_id/#{fullname}.json"
        end

        # @!method get_hot
        # @!method get_new
        # @!method get_random
        # @!method get_top
        # @!method get_controversial
        # @!method get_comments
        #
        # Get the appropriate listing.
        # @param subreddit [Redd::Object::Subreddit] The subreddit to query.
        # @param params [Hash] A list of params to send with the request.
        #
        # @see #get_listing
        %i(hot new random top controversial comments).each do |sort|
          define_method "get_#{sort}" do |subreddit = nil, params = {}|
            get_listing(sort, subreddit, params)
          end
        end

        private

        # Get the front page of reddit or a subreddit sorted by type.
        #
        # @param type [:hot, :new, :random, :top, :controversial, :comments]
        #   The type of listing to return 
        # @param subreddit [Redd::Object::Subreddit] The subreddit to query.
        # @param params [Hash] A list of params to send with the request.
        # @option params [String] :after Return results after the given
        #   fullname.
        # @option params [String] :before Return results before the given
        #   fullname.
        # @option params [Integer] :count The number of items already seen in
        #   the listing.
        # @option params [1..100] :limit (25) The maximum number of things to
        #   return.
        # @option params [:hour, :day, :week, :month, :year, :all] :t The
        #   time period to consider when sorting.
        # @return [Redd::Object::Listing] A listing of submissions or comments.
        #
        # @note The option :t only applies to the top and controversial sorts.
        def get_listing(type, subreddit = nil, params = {})
          name = extract_attribute(subreddit, :display_name) if subreddit

          path = "/#{type}.json"
          path = path.prepend("/r/#{name}") if name

          object_from_response :get, path, params
        end
      end
    end
  end
end
