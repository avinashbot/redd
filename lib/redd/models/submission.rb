# frozen_string_literal: true

require_relative 'lazy_model'
require_relative 'moderatable'
require_relative 'postable'
require_relative 'replyable'

require_relative 'user'
require_relative 'subreddit'

module Redd
  module Models
    # A text or link post.
    class Submission < LazyModel
      include Moderatable
      include Postable
      include Replyable

      # Create a Subreddit from its fullname.
      # @param client [APIClient] the api client to initialize the object with
      # @param id [String] the fullname
      # @return [Submission]
      def self.from_id(client, id)
        new(client, name: id)
      end

      # Get all submissions for the same url.
      # @param params [Hash] A list of optional params to send with the request.
      # @option params [String] :after return results after the given fullname
      # @option params [String] :before return results before the given fullname
      # @option params [Integer] :count (0) the number of items already seen in the listing
      # @option params [1..100] :limit (25) the maximum number of things to return
      # @return [Listing<Submission>]
      def duplicates(**params)
        @client.unmarshal(@client.get("/duplicates/#{get_attribute(:id)}", params).body[1])
      end

      # Mark the link as "Not Suitable For Work".
      def mark_as_nsfw
        @client.get('/api/marknsfw', id: get_attribute(:name))
        @attributes[:over_18] = true
      end

      # No longer mark the link as "Not Suitable For Work".
      def unmark_as_nsfw
        @client.get('/api/unmarknsfw', id: get_attribute(:name))
        @attributes[:over_18] = false
      end

      # Mark the link as a spoiler.
      def mark_as_spoiler
        @client.get('/api/spoiler', id: get_attribute(:name))
        @attributes[:spoiler] = true
      end

      # No longer mark the link as a spoiler.
      def unmark_as_spoiler
        @client.get('/api/unspoiler', id: get_attribute(:name))
        @attributes[:spoiler] = false
      end

      # Set the submission to "contest mode" (comments are randomly sorted)
      def enable_contest_mode
        @client.post('/api/set_contest_mode', id: get_attribute(:name), state: true)
      end

      # Disable the "contest mode".
      def disable_contest_mode
        @client.post('/api/set_contest_mode', id: get_attribute(:name), state: false)
      end

      # Set the submission as the sticky post of the subreddit.
      # @param slot [1, 2] which "slot" to place the sticky on
      def make_sticky(slot: nil)
        @client.post('/api/set_subreddit_sticky', id: get_attribute(:name), num: slot, state: true)
      end

      # Unsticky the post from the subreddit.
      def remove_sticky
        @client.post('/api/set_subreddit_sticky', id: get_attribute(:name), state: false)
      end

      # Prevent users from commenting on the link (and hide it as well).
      def lock
        @client.post('/api/lock', id: get_attribute(:name))
      end

      # Allow users to comment on the link again.
      def unlock
        @client.post('/api/unlock', id: get_attribute(:name))
      end

      private

      def default_loader
        # Ensure we have the link's id.
        id = @attributes[:id] ? @attributes[:id] : @attributes.fetch(:name).sub('t3_', '')
        response = @client.get("/comments/#{id}").body
        # `response` is a pair (2-element array):
        #   - response[0] is a one-item listing containing the submission
        #   - response[1] is listing of comments
        response[0][:data][:children][0][:data].merge(comments: @client.unmarshal(response[1]))
      end

      def after_initialize
        if @attributes[:subreddit]
          @attributes[:subreddit] = Subreddit.from_id(@client, @attributes[:subreddit])
        end
        @attributes[:author] = User.from_id(@client, @attributes[:author]) if @attributes[:author]
      end
    end
  end
end
