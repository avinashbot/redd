# frozen_string_literal: true

require_relative 'lazy_model'
require_relative 'inboxable'
require_relative 'moderatable'
require_relative 'postable'
require_relative 'replyable'

require_relative 'listing'
require_relative 'subreddit'
require_relative 'user'

module Redd
  module Models
    # A comment.
    class Comment < LazyModel
      include Inboxable
      include Moderatable
      include Postable
      include Replyable

      coerce_attribute :replies
      coerce_attribute :author, User
      coerce_attribute :subreddit, Subreddit

      # Make a Comment from its id.
      # @option hash [String] :name the comment's fullname (e.g. t1_abc123)
      # @option hash [String] :id the comment's id (e.g. abc123)
      # @return [Comment]
      def self.from_response(client, hash)
        # FIXME: listings can be empty... (for some reason)

        # Ensure we have the comment's id.
        id = hash.fetch(:id) { hash.fetch(:name).tr('t1_', '') }

        # If we have the link_id, we can load the listing with replies.
        if hash.key?(:link_id)
          link_id = hash[:link_id].tr('t3_', '')
          return new(client, hash) do |c|
            # The second half contains a single-item listing containing the comment
            c.get("/comments/#{link_id}/_/#{id}").body[1][:data][:children][0][:data]
          end
        end

        # We can only load the comment in isolation if we don't have the link_id.
        new(client, hash) do |c|
          # Returns a single-item listing containing the comment
          c.get('/api/info', id: "t1_#{id}").body[:data][:children][0][:data]
        end
      end

      private

      def after_initialize
        @attributes[:replies] = [] if !@attributes.key?(:replies) || @attributes[:replies] == ''
      end
    end
  end
end
