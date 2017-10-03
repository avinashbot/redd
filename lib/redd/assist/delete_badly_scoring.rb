# frozen_string_literal: true

module Redd
  module Assist
    # Helper class for deleting negative links or comments. You can run this as a separate process,
    # as long as you set your rate limit time higher in your main process.
    # @note Works with {Submission} and {Comment}.
    # @example
    #   assist = Redd::Assist::DeleteBadlyScoring.new(session.client)
    #   assist.track(comment)
    #   loop do
    #     assist.delete_badly_scoring(under_score: 1, minimum_age: 600)
    #     sleep 30
    #   end
    class DeleteBadlyScoring
      # Create a DeleteBadlyScoring assist.
      # @param client [APIClient] the API client
      def initialize(client)
        @client = client
        @queue = []
      end

      # Add this model's id to the list of items that are tracked.
      def track(model)
        @queue << model.name
      end

      # Delete all items that are older than the minimum age and score 0 or below.
      # @param under_score [Integer] the maximum score that the comment must have to be kept
      # @param minimum_age [Integer] the minimum age for deletion (seconds)
      # @return [Array<String>] the deleted item fullnames
      def delete_badly_scoring!(under_score: 1, minimum_age: 15 * 60)
        delete_if do |comment|
          if comment.created_at + minimum_age > Time.now
            :skip
          elsif comment.score < under_score && !comment.deleted? && !comment.archived?
            :delete
          else
            :keep
          end
        end
      end

      # Delete all items that the block returns true for.
      # @param minimum_age [Integer] the minimum age for deletion
      # @yieldparam comment [Comment] the comment to filter
      # @yieldreturn [:keep, :delete, :skip] whether to keep, delete, or check again later
      # @return [Array<String>] the deleted item fullnames
      def delete_if
        deleted = []
        @queue.delete_if do |fullname|
          comment = Models::Comment.new(@client, name: fullname).reload
          action = yield comment
          if action == :delete
            comment.delete
            deleted << fullname
          end
          action == :keep || action == :delete
        end
        deleted
      end
    end
  end
end
