# frozen_string_literal: true

module Redd
  module Assist
    # Helper class for deleting negative links or comments. You can run this as a separate process,
    # as long as you set your rate limit time higher in your main process.
    # @note Works with {Submission} and {Comment}.
    class DeleteNegative
      # Create a DeleteNegative assist.
      # @param client [APIClient] the API client
      # @example
      #   assist = Redd::Assist::DeleteNegative.new(session.client)
      def initialize(client)
        @client = client
        @queue = []
      end

      # Add this model's id to the list of items that are tracked.
      def track(model)
        @queue << model.name
      end

      # Delete all items that are older than the minimum age and score 0 or below.
      # @param minimum_age [Integer] the minimum age for deletion (seconds)
      # @return [Array<String>] the deleted item fullnames
      def delete_all_not_positive!(minimum_age: 15 * 60)
        delete_if do |comment|
          # optimization: break now since all future comments will be younger
          break if comment.created_at + minimum_age > Time.now
          comment.score <= 0 && !comment.deleted? && !comment.archived?
        end
      end

      # Delete all items that are older than the minimum age and score -1 or below.
      # @param minimum_age [Integer] the minimum age for deletion (seconds)
      # @return [Array<String>] the deleted item fullnames
      def delete_all_negative!(minimum_age: 15 * 60)
        delete_if do |comment|
          # optimization: break now since all future comments will be younger
          break if comment.created_at + minimum_age > Time.now
          comment.score < 0 && !comment.deleted? && !comment.archived?
        end
      end

      # Delete all items that the block returns true for.
      # @param minimum_age [Integer] the minimum age for deletion
      # @yieldparam comment [Comment] the comment to filter
      # @yieldreturn [Boolean] whether to delete the comment
      # @return [Array<String>] the deleted item fullnames
      def delete_if
        deleted = []
        @queue.delete_if do |fullname|
          should_delete = yield Models::Comment.new(@client, name: fullname).reload
          if should_delete
            comment.delete
            deleted << fullname
          end
          should_delete
        end
        deleted
      end
    end
  end
end
