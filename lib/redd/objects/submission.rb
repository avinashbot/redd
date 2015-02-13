require_relative "thing"

module Redd
  module Objects
    # A submission made in a subreddit.
    class Submission < Thing
      include Thing::Editable
      include Thing::Hideable
      include Thing::Moderatable
      include Thing::Refreshable
      include Thing::Saveable
      include Thing::Votable

      alias_property :nsfw?, :over_18
      alias_property :self?, :is_self
      alias_property :comments_count, :num_comments

      # The shorter url for sharing.
      def short_url
        "http://redd.it/#{self[:id]}"
      end

      # Whether the comment was gilded.
      def gilded?
        self[:gilded] > 0
      end

      # @return [Listing] The submission's comments.
      # @todo Allow for various depths and contexts and what not. Maybe a
      #   get_comment method?
      def comments
        refresh! unless @comments
        @comments
      end

      # @return [Array<Comment, MoreComments>] A linear array of the
      #   submission's comments.
      # @todo Somehow implement. Maybe a recursive method belonging to a
      #   CommentListing<Comment, MoreComments>?
      def flat_comments
        fail NotImplementedError
      end

      # Refresh the submission AND its comments.
      # @return [Submission] The updated submission.
      def refresh!
        body = get("/comments/#{id}.json").body
        @comments = client.object_from_body(body[1])
        deep_merge!(body[0])
      end

      # Take a MoreComments and return a listing of comments.
      # @param [MoreComments] more The object to expand.
      # @return [Listing] A listing of the expanded comments.
      def expand_more(more)
        response = client.get(
          "/api/morechildren",
          children: more.join(","),
          link_id: fullname
        )

        client.object_from_body(
          kind: "Listing",
          data: {
            before: "", after: "",
            children: response.body[:json][:data][:things]
          }
        )
      end
    end
  end
end
