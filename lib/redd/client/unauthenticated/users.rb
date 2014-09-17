module Redd
  module Client
    class Unauthenticated
      # Methods to interact with other redditors
      module Users
        # Return a User object from the username of a redditor.
        # @param username [String] The username.
        # @return [Redd::Object::User]
        def user(username)
          object_from_response :get, "/user/#{username}/about.json"
        end

        # @!method get_user_overview
        # @!method get_user_submitted
        # @!method get_user_comments
        # @!method get_user_liked
        # @!method get_user_disliked
        # @!method get_user_hidden
        # @!method get_user_saved
        # @!method get_user_gilded
        #
        # Get the appropriate listing.
        # @param user [Redd::Object::User] The user to query.
        # @param params [Hash] A list of params to send with the request.
        #
        # @see #get_user_listing
        %w(
          overview submitted comments liked disliked hidden saved gilded
        ).each do |sort|
          define_method :"get_user_#{sort}" do |user, params = {}|
            get_user_listing(user, sort, params)
          end
        end

        private

        # Get comments and submissions related to a user.
        #
        # @param user [Redd::Object::User, String] The user to query.
        # @param type [:overview, :submitted, :comments, :liked, :disliked,
        #   :hidden, :saved, :gilded] The type of listing to return.
        # @param params [Hash] A list of params to send with the request.
        # @option params [String] :after Return results after the given
        #   fullname.
        # @option params [String] :before Return results before the given
        #   fullname.
        # @option params [Integer] :count (0) The number of items already seen
        #   in the listing.
        # @option params [1..100] :limit (25) The maximum number of things to
        #   return.
        # @option params [:hot, :new, :top, :controversial] :sort The order to
        #   sort the results by.
        # @option params [:hour, :day, :week, :month, :year, :all] :t The
        #   time period to consider when sorting.
        # @return [Redd::Object::Listing] A listing of submissions or comments.
        def get_user_listing(user, type, params = {})
          name = extract_attribute(user, :name)
          path = "/user/#{name}/#{type}.json"
          params[:show] ||= :given

          object_from_response :get, path, params
        end
      end
    end
  end
end
