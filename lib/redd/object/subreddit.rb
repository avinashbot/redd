require "redd/thing"

module Redd
  module Object
    # A comment made on links.
    # @note This model can sure benefit from some lazy-loading...
    class Subreddit < Redd::Thing
      attr_reader :display_name
      attr_reader :title

      attr_reader :description
      attr_reader :description_html

      attr_reader :header_image, :header_img
      attr_reader :header_title
      attr_reader :header_size

      attr_reader :user_is_banned?, :user_is_banned
      attr_reader :user_is_contributor?, :user_is_contributor
      attr_reader :user_is_moderator?, :user_is_moderator
      attr_reader :user_is_subscriber?, :user_is_subscriber

      attr_reader :submit_text
      attr_reader :submit_text_html
      attr_reader :submit_link_label
      attr_reader :submit_text_label

      attr_reader :nsfw?, :over18
      attr_reader :users_online, :accounts_active
      attr_reader :traffic_is_public?, :public_traffic
      attr_reader :subscribers
      attr_reader :created_utc
      attr_reader :comment_score_hide_mins
      attr_reader :type, :subreddit_type
      attr_reader :submission_type

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
