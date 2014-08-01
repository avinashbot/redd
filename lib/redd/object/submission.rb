require "redd/thing"

module Redd
  module Object
    # A submission made in a subreddit.
    class Submission < Redd::Thing
      attr_reader :created_utc
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

      def subreddit
        @subreddit ||= client.subreddit(@attributes[:subreddit])
      end

      def created
        @created ||= Time.at(@attributes[:created])
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
