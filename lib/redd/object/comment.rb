require "redd/thing"

module Redd
  module Object
    # A comment made on links.
    class Comment < Redd::Thing
      require "redd/thing/editable"
      require "redd/thing/inboxable"
      require "redd/thing/moderatable"
      require "redd/thing/reportable"
      require "redd/thing/voteable"

      include Redd::Thing::Editable
      include Redd::Thing::Inboxable
      include Redd::Thing::Moderatable
      include Redd::Thing::Reportable
      include Redd::Thing::Voteable

      attr_reader :created_utc
      attr_reader :author

      attr_reader :edited
      attr_reader :saved
      attr_reader :gilded

      attr_reader :ups
      attr_reader :downs
      attr_reader :score
      attr_reader :likes
      attr_reader :controversiality

      attr_reader :banned_by
      attr_reader :approved_by
      attr_reader :score_hidden
      attr_reader :distinguished
      attr_reader :num_reports

      attr_reader :parent_id
      attr_reader :link_id
      attr_reader :body
      attr_reader :body_html
      attr_reader :author_flair_text
      attr_reader :author_flair_css_class

      alias_method :reports_count, :num_reports

      def replies
        @replies ||= client.get_replies(self)
      end

      def subreddit
        @subreddit ||= client.subreddit(@attributes[:subreddit])
      end

      def created
        @created ||= Time.at(@attributes[:created])
      end

      def root?
        !parent_id || parent_id == link_id
      end

      def gilded?
        gilded > 0
      end
    end
  end
end
