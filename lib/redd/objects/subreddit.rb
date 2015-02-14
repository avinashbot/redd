require_relative "thing"

module Redd
  module Objects
    # A comment made on links.
    # @todo #subscribe! and #unsubscribe!
    class Subreddit < Thing
      include Thing::Messageable
      include Thing::Refreshable

      alias_property :header_image, :header_img
      alias_property :nsfw?, :over18
      alias_property :users_online, :accounts_active
      alias_property :type, :subreddit_type
      alias_property :times_gilded, :gilded

      # @return [String] The url for the subreddit's stylesheet.
      def stylesheet_url
        get("/r/#{display_name}/stylesheet").headers["location"]
      end

      # @return [String] The css for the subreddit.
      def stylesheet
        Faraday.get(stylesheet_url).body
      end

      # Accept a moderator invite from a subreddit.
      def accept_moderator_invite!
        post("/r/#{display_name}/api/accept_moderator_invite")
      end

      # Stop being a contributor of the subreddit.
      def leave_contributor_status!
        post("/api/leavecontributor", id: fullname)
      end

      # Stop being a moderator of the subreddit.
      def leave_moderator_status!
        post("/api/leavemoderator", id: fullname)
      end

      # Get a list of everbody on the subreddit with a user flair.
      #
      # @param [Hash] params A list of params to send with the request.
      # @option params [String] :after Return results after the given
      #   fullname.
      # @option params [String] :before Return results before the given
      #   fullname.
      # @option params [Integer] :count The number of items already seen in the
      #   listing.
      # @option params [1..1000] :limit The maximum number of things to
      #   return.
      # @option params [String] :name The username when getting the flair of
      #   just one user.
      # @return [Objects::Listing<Hash>] A listing of flair hashes.
      def get_flairlist(**params)
        body = get("/r/#{display_name}/api/flairlist.json", params).body
        client.object_from_body(
          kind: "Listing",
          data: {
            children: body[:users],
            before: body[:prev],
            after: body[:next]
          }
        )
      end

      # Get the flair of a user.
      #
      # @param [Objects::User, String] user The user to find.
      # @return [Hash, nil] Flair info about the user or nil if nobody was
      #   found.
      def get_flair(user)
        username = client.property(user, :name)
        flair = get_flairlist(user: username).first
        flair if flair[:user].casecmp(username) == 0
      end

      # Set the flair of a user or link.
      # @param [Objects::Subreddit, Objects::User] thing The user or link to
      #   set the flair to.
      # @param [:user, :link] type The type of thing.
      # @param [String] text The text to set the flair to.
      # @param [String] css_class The css_class of the flair.
      def set_flair(thing, type = nil, text = nil, css_class = nil)
        if thing.is_a?(Objects::User) || type == :user
          params[:name] = client.property(thing, :name)
        elsif thing.is_a?(Objects::Submission) || type == :user
          params[:link] = client.property(thing, :fullname)
        else
          fail "You should provide a proper type."
        end

        post("/r/#{display_name}/api/flair", text: text, css_class: css_class)
      end

      # @!method get_hot(**params)
      # @!method get_new(**params)
      # @!method get_top(**params)
      # @!method get_controversial(**params)
      # @!method get_comments(**params)
      #
      # Get the appropriate listing.
      # @param params [Hash] A list of params to send with the request.
      # @option params [String] :after Return results after the given
      #   fullname.
      # @option params [String :before Return results before the given
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
        define_method :"get_#{sort}" do |**params|
          client.send(:"get_#{sort}", self, **params)
        end
      end

      # @!method get_reports(**params)
      # @!method get_spam(**params)
      # @!method get_modqueue(**params)
      # @!method get_unmoderated(**params)
      # @!method get_edited(**params)
      #
      # Get the appropriate moderator listing.
      # @param [Hash] params A list of params to send with the request.
      # @option params [String] :after Return results after the given
      #   fullname.
      # @option params [String] :before Return results before the given
      #   fullname.
      # @option params [Integer] :count The number of items already seen
      #   in the listing.
      # @option params [1..100] :limit The maximum number of things to
      #   return.
      # @option params :location No idea what this does.
      # @option params [:links, :comments] :only The type of things to show.
      #
      # @return [Objects::Listing<Objects::Thing>]
      # @see https://www.reddit.com/dev/api#GET_about_{location}
      %w(reports spam modqueue unmoderated edited).each do |sort|
        define_method :"get_#{sort}" do |**params|
          request_object(:get, "/r/#{display_name}/about/#{sort}", params)
        end
      end
    end
  end
end
