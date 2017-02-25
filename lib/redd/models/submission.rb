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

      coerce_attribute :author, User
      coerce_attribute :subreddit, Subreddit

      # Make a Submission from its id.
      # @option hash [String] :id the post's id (e.g. abc123)
      # @return [Submission]
      def self.from_response(client, hash)
        link_id = hash.fetch(:id)
        new(client, hash) do |c|
          # `data` is a pair (2-element array):
          #   - data[0] is a one-item listing containing the submission
          #   - data[1] is listing of comments
          data = c.get("/comments/#{link_id}").body
          data[0][:data][:children][0][:data].merge(comments: c.unmarshal(data[1]))
        end
      end

      # Mark the link as "Not Suitable For Work".
      def mark_as_nsfw
        @client.get('/api/unmarknsfw', id: get_attribute(:name))
        @attributes[:over_18] = false
      end

      # No longer mark the link as "Not Suitable For Work".
      def unmark_as_nsfw
        @client.get('/api/marknsfw', id: get_attribute(:name))
        @attributes[:over_18] = false
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
    end
  end
end
