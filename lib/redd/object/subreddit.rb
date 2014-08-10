require "redd/thing"

module Redd
  module Object
    # A comment made on links.
    # @note This model can sure benefit from some lazy-loading...
    class Subreddit < Redd::Thing
      require "redd/thing/messageable"

      include Redd::Thing::Messageable

      attr_reader :display_name
      attr_reader :title

      attr_reader :description
      attr_reader :description_html

      attr_reader :header_img
      attr_reader :header_title
      attr_reader :header_size

      attr_reader :user_is_banned
      attr_reader :user_is_contributor
      attr_reader :user_is_moderator
      attr_reader :user_is_subscriber

      attr_reader :submit_text
      attr_reader :submit_text_html
      attr_reader :submit_link_label
      attr_reader :submit_text_label

      attr_reader :over18
      attr_reader :accounts_active
      attr_reader :public_traffic
      attr_reader :subscribers
      attr_reader :created_utc
      attr_reader :comment_score_hide_mins
      attr_reader :subreddit_type
      attr_reader :submission_type

      alias_method :header_image, :header_img
      alias_method :nsfw?, :over18
      alias_method :users_online, :accounts_active
      alias_method :type, :subreddit_type

      def created
        @created ||= Time.at(@attributes[:created])
      end

      def url
        "http://reddit.com" + @attributes[:url]
      end

      def get_hot(*args)
        client.get_hot(display_name, *args)
      end

      def get_new(*args)
        client.get_new(display_name, *args)
      end

      def get_random(*args)
        client.get_random(display_name, *args)
      end

      def get_top(*args)
        client.get_top(display_name, *args)
      end

      def get_controversial(*args)
        client.get_controversial(display_name, *args)
      end
    end
  end
end
