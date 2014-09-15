require "redd/thing"

module Redd
  module Object
    # A submission made in a subreddit.
    class Submission < Redd::Thing
      require "redd/thing/commentable"
      require "redd/thing/editable"
      require "redd/thing/hideable"
      require "redd/thing/moderatable"
      require "redd/thing/reportable"
      require "redd/thing/saveable"
      require "redd/thing/voteable"

      include Redd::Thing::Commentable
      include Redd::Thing::Editable
      include Redd::Thing::Hideable
      include Redd::Thing::Moderatable
      include Redd::Thing::Saveable
      include Redd::Thing::Voteable

      attr_reader :author

      attr_reader :edited
      attr_reader :saved
      attr_reader :gilded
      attr_reader :clicked
      attr_reader :visited
      attr_reader :stickied
      attr_reader :hidden

      attr_reader :ups
      attr_reader :downs
      attr_reader :score
      attr_reader :likes

      attr_reader :banned_by
      attr_reader :approved_by
      attr_reader :distinguished
      attr_reader :num_reports

      attr_reader :link_flair_text
      attr_reader :link_flair_css_class
      attr_reader :author_flair_css_class
      attr_reader :author_flair_text

      attr_reader :domain
      attr_reader :media
      attr_reader :media_embed
      attr_reader :selftext
      attr_reader :selftext_html
      attr_reader :secure_media
      attr_reader :secure_media_embed
      attr_reader :over_18
      attr_reader :thumbnail
      attr_reader :is_self
      attr_reader :url
      attr_reader :title
      attr_reader :num_comments

      alias_method :nsfw?, :over_18
      alias_method :self?, :is_self
      alias_method :comments_count, :num_comments

      def subreddit_name
        @subreddit_name ||= @attributes[:subreddit]
      end

      def subreddit
        @subreddit ||= client.subreddit(@attributes[:subreddit])
      end

      def comments
        @comments ||= client.submission_comments(id)
      end

      def created
        @created ||= Time.at(@attributes[:created_utc])
      end

      def permalink
        "http://www.reddit.com" + attributes[:permalink]
      end

      def short_url
        "http://redd.it/" + id
      end

      def gilded?
        gilded > 0
      end
    end
  end
end
