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
          # `details` is a pair (2-element array):
          #   - details[0] is a one-item listing containing the submission
          #   - details[1] is listing of comments
          details = c.get("/comments/#{link_id}").body
          comments = details[1][:data][:children].map do |comment_object|
            Comment.from_response(c, comment_object[:data])
          end
          details[0][:data][:children][0][:data].merge(comments: comments)
        end
      end
    end
  end
end
