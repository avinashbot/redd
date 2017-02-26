# frozen_string_literal: true

require_relative 'lazy_model'
require_relative 'searchable'

module Redd
  module Models
    # The starter class.
    class Session < BasicModel
      include Searchable

      # @return [FrontPage] the user's front page
      def front_page
        FrontPage.new(@client)
      end

      # @return [User] the logged-in user
      def me
        User.new(@client) { |client| client.get('/api/v1/me').body }
      end

      # Get a (lazily loaded) reddit user by their name.
      # @param name [String] the username
      # @return [User]
      def user(name)
        User.from_id(@client, name)
      end

      # Get a (lazily loaded) subreddit by its name.
      # @param display_name [String] the subreddit's display name
      # @return [Subreddit]
      def subreddit(display_name)
        Subreddit.from_id(@client, display_name)
      end

      # @return [Array<Multireddit>] array of multireddits belonging to the user
      def my_multis
        @client.get('/api/multi/mine').body.map { |m| @client.unmarshal(m) }
      end

      # Get a (lazily loaded) multi by its path.
      # @param path [String] the multi's path, prepended by a /
      # @return [Multireddit]
      def multi(path)
        Multireddit.from_id(@client, path)
      end

      # Get submissions or comments by their fullnames.
      # @param fullnames [String, Array<String>] one or an array of fullnames (e.g. t3_abc1234)
      # @return [Listing<Submission, Comment>]
      def from_ids(fullnames)
        # XXX: Could we use better methods for t1_ and t3_?
        @client.model(:get, '/api/info', id: Array(fullnames).join(','))
      end

      # Get submissions or comments by their fullnames.
      # @param url [String] the object's url
      # @return [Submission, Comment, nil] the object, or nil if not found
      def from_url(url)
        @client.model(:get, '/api/info', url: url).first
      end

      # Return a listing of the user's inbox (including comment replies and private messages).
      #
      # @param category ['inbox', 'unread', 'sent'] The category of messages
      #   to view.
      # @param mark [Boolean] Whether to remove the orangered from the
      #   user's inbox.
      # @param params [Hash] A list of optional params to send with the request.
      # @option params [String] :after Return results after the given
      #   fullname.
      # @option params [String] :before Return results before the given
      #   fullname.
      # @option params [Integer] :count (0) The number of items already seen
      #   in the listing.
      # @option params [1..100] :limit (25) The maximum number of things to
      #   return.
      # @return [Listing]
      def my_messages(category: 'inbox', mark: false, **params)
        @client.model(:get, "/message/#{category}.json", params.merge(mark: mark))
      end

      # Mark all messages as read.
      def read_all_messages
        @client.post('/api/read_all_messages')
      end
    end
  end
end
