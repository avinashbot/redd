# frozen_string_literal: true

require_relative 'model'
require_relative 'searchable'

module Redd
  module Models
    # The starter class.
    class Session < Model
      include Searchable

      # @return [User] the logged-in user
      def me
        @me ||= Self.new(client)
      end

      # @return [FrontPage] the user's front page
      def front_page
        @front_page ||= FrontPage.new(client)
      end

      # @return [Modmail] the new modmail
      def modmail
        @modmail ||= Modmail.new(client)
      end

      # @return [LiveThread] the live thread
      def live_thread(id)
        LiveThread.new(client, id: id)
      end

      # @return [Hash] a breakdown of karma over subreddits
      def karma_breakdown
        client.get('/api/v1/me/karma').body[:data]
      end

      # Get a (lazily loaded) reddit user by their name.
      # @param name [String] the username
      # @return [User]
      def user(name)
        User.new(client, name: name)
      end

      # Returns whether a username is available.
      # @param username [String] the username to check
      # @return [Boolean] whether the username is available
      def username_available?(username)
        client.get('/api/username_available', user: username).body
      end

      # Get a (lazily loaded) subreddit by its name.
      # @param display_name [String] the subreddit's display name
      # @return [Subreddit]
      def subreddit(display_name)
        Subreddit.new(client, display_name: display_name)
      end

      # @return [Array<Multireddit>] array of multireddits belonging to the user
      def my_multis
        client.get('/api/multi/mine').body.map { |m| client.unmarshal(m) }
      end

      # Get a (lazily loaded) multi by its path.
      # @param path [String] the multi's path, surrounded by a leading and trailing /
      # @return [Multireddit]
      def multi(path)
        Multireddit.new(client, path: path)
      end

      # Get submissions or comments by their fullnames.
      # @param fullnames [String, Array<String>] one or an array of fullnames (e.g. t3_abc1234)
      # @return [Listing<Submission, Comment>]
      # @deprecated Try the lazier {#from_fullnames} instead.
      def from_ids(*fullnames)
        client.model(:get, '/api/info', id: fullnames.join(','))
      end

      # Create lazily-loaded objects from their fullnames (e.g. t1_abc123).
      # @param fullnames [String] fullname for a submission, comment, or subreddit.
      # @return [Array<Submission, Comment, User, Subreddit>]
      def from_fullnames(*fullnames)
        fullnames.map do |name|
          if name.start_with?('t1_')
            Comment.new(client, name: name)
          elsif name.start_with?('t3_')
            Submission.new(client, name: name)
          elsif name.start_with?('t5_')
            Subreddit.new(client, name: name)
          else
            raise "unknown fullname #{name}"
          end
        end
      end

      # Get submissions or comments by their fullnames.
      # @param url [String] the object's url
      # @return [Submission, Comment, nil] the object, or nil if not found
      def from_url(url)
        client.model(:get, '/api/info', url: url).first
      end

      # Return a listing of the user's inbox (including comment replies and private messages).
      #
      # @param category ['inbox', 'unread', 'sent', 'moderator', 'messages', 'comments',
      #   'selfreply', 'mentions'] the category of messages to view
      # @param mark [Boolean] whether to remove the orangered from the user's inbox
      # @param params [Hash] a list of optional params to send with the request
      # @option params [String] :after return results after the given fullname
      # @option params [String] :before return results before the given fullname
      # @option params [Integer] :count (0) the number of items already seen in the listing
      # @option params [1..100] :limit (25) the maximum number of things to return
      # @return [Listing<Comment, PrivateMessage>]
      def my_messages(category: 'inbox', mark: false, **params)
        client.model(:get, "/message/#{category}.json", params.merge(mark: mark))
      end

      # Mark all messages as read.
      def read_all_messages
        client.post('/api/read_all_messages')
      end

      # @return [Hash] the user's preferences
      def my_preferences
        client.get('/api/v1/me/prefs').body
      end

      # Edit the user's preferences.
      # @param new_prefs [Hash] the changed preferences
      # @return [Hash] the new preferences
      # @see #my_preferences
      def edit_preferences(new_prefs = {})
        client.request(
          :patch, '/api/v1/me/prefs',
          headers: { 'Content-Type' => 'application/json' },
          body: JSON.generate(new_prefs)
        ).body
      end

      # @return [Array<User>] the logged-in user's friends
      def friends
        client.get('/api/v1/me/friends').body[:data][:children].map do |h|
          User.new(client, name: h[:name], id: h[:id].sub('t2_', ''), since: h[:date])
        end
      end

      # @return [Array<User>] users blocked by the logged-in user
      def blocked
        client.get('/prefs/blocked').body[:data][:children].map do |h|
          User.new(client, name: h[:name], id: h[:id].sub('t2_', ''), since: h[:date])
        end
      end

      # @return [Array<User>] users trusted by the logged-in user
      def trusted
        client.get('/prefs/trusted').body[:data][:children].map do |h|
          User.new(client, name: h[:name], id: h[:id].sub('t2_', ''), since: h[:date])
        end
      end

      # @return [Array<String>] a list of categories the user's items are saved in
      def saved_categories
        client.get('/api/saved_categories').body
      end

      # Return a listing of the user's subreddits.
      #
      # @param type ['subscriber', 'contributor', 'moderator'] the type of subreddits
      # @param params [Hash] a list of optional params to send with the request
      # @option params [String] :after return results after the given fullname
      # @option params [String] :before return results before the given fullname
      # @option params [Integer] :count (0) the number of items already seen in the listing
      # @option params [1..100] :limit (25) the maximum number of things to return
      # @return [Listing<Subreddit>]
      def my_subreddits(type, **params)
        client.model(:get, "/subreddits/mine/#{type}", params)
      end

      # Return trending subreddits.
      # @return [Hash]
      # @example
      #   session.trending_subreddits
      #   => {
      #     "subreddit_names": [
      #       "AskLibertarians",
      #       "OpTicGaming",
      #       "Cuphead",
      #       "AlmostParkour",
      #       "TheGoodPlace"
      #     ],
      #     "comment_count": 176,
      #     "comment_url": "/r/trendingsubreddits/comments/73dkin/trending_subreddits_for_..."
      #   }
      def trending_subreddits
        client.get('/api/trending_subreddits').body
      end

      # Return a listing of subreddits
      #
      # @param order ['default', 'popular', 'new', 'gold'] the order of returned subreddits
      # @param params [Hash] a list of optional params to be send with the request
      # @option params [String] :after return results after the given fullname
      # @option params [String] :before return results before the given fullname
      # @option params [Integer] :count (0) the number of items already seen in the listing
      # @option params [1..100] :limit (25) the maximum number of things to return
      # @return [Listing<Subreddit>]
      def list_subreddits(order = 'default', **params)
        client.model(:get, "/subreddits/#{order}", params)
      end

      # Search subreddits
      #
      # @param query [String] the search query
      # @param params [Hash] the search params
      # @option params [String] :after return results after the given fullname
      # @option params [String] :before return results before the given fullname
      # @option params [Integer] :count the number of items already seen in the listing
      # @option params [1..100] :limit the maximum number of things to return
      # @option params [:relevance, :activity] :sort the sort order of results
      # @return [Listing<Subreddit>] the search results
      def search_subreddits(query, **params)
        params[:q] = query
        client.model(:get, '/subreddits/search', params)
      end
    end
  end
end
