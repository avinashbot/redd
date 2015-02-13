require_relative "thing"

module Redd
  module Objects
    # A comment made on links.
    class Subreddit < Thing
      include Thing::Messageable
      include Thing::Refreshable

      alias_property :header_image, :header_img
      alias_property :nsfw?, :over18
      alias_property :users_online, :accounts_active
      alias_property :type, :subreddit_type
      alias_property :times_gilded, :gilded

      # @!group Stylesheets

      # @return [String] The url for the subreddit's stylesheet.
      def stylesheet_url
        get("/r/#{display_name}/stylesheet").headers["location"]
      end

      # @return [String] The css for the subreddit.
      def stylesheet
        Faraday.get(stylesheet_url).body
      end

      # @!endgroup

      # @!group Invites

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

      # @!endgroup
    end
  end
end
