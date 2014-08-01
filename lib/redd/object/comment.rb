require "redd/thing"

module Redd
  module Object
    # A comment made on links.
    class Comment < Redd::Thing
      attr_reader :created_utc

      attr_reader :edited

      attr_reader :ups
      attr_reader :downs
      attr_reader :score
      attr_reader :likes
      attr_reader :controversiality

      attr_reader :author
      attr_reader :parent_id
      attr_reader :body
      attr_reader :body_html
      attr_reader :author_flair_text
      attr_reader :author_flair_css_class

      def subreddit
        @subreddit ||= client.subreddit(@attributes[:subreddit])
      end

      def created
        @created ||= Time.at(@attributes[:created])
      end

      def root?
        !parent_id || parent_id == fullname
      end
    end
  end
end
