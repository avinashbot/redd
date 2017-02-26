# frozen_string_literal: true

module Redd
  module Models
    # Methods for user-submitted content, i.e. Submissions and Comments.
    module Postable
      # Edit a thing.
      # @param text [String] The new text.
      # @return [self] the edited thing
      def edit(text)
        @client.post('/api/editusertext', thing_id: get_attribute(:name), text: text)
        @attributes[is_a?(Submission) ? :selftext : :body] = text
        self
      end

      # Delete the thing.
      def delete
        @client.post('/api/del', id: get_attribute(:name))
      end

      # Save a link or comment to the user's account.
      # @param category [String] a category to save to
      def save(category = nil)
        params = { id: fullname }
        params[:category] = category if category
        @client.post('/api/save', params)
      end

      # Remove the link or comment from the user's saved links.
      def unsave
        @client.post('/api/unsave', id: get_attribute(:name))
      end

      # Hide a link from the user.
      def hide
        @client.post('/api/hide', id: get_attribute(:fullname))
      end

      # Unhide a previously hidden link.
      def unhide
        @client.post('/api/unhide', id: get_attribute(:fullname))
      end

      # Upvote the model.
      def upvote
        vote(1)
      end

      # Downvote the model.
      def downvote
        vote(-1)
      end

      # Clear any upvotes or downvotes on the model.
      def undo_vote
        vote(0)
      end

      # Send replies to this thing to the user's inbox.
      def enable_inbox_replies
        @client.post('/api/sendreplies', id: get_attribute(:name), state: true)
      end

      # Stop sending replies to this thing to the user's inbox.
      def disable_inbox_replies
        @client.post('/api/sendreplies', id: get_attribute(:name), state: false)
      end

      private

      # Send a vote.
      # @param direction [-1, 0, 1] the direction to vote in
      def vote(direction)
        fullname = get_attribute(:name)
        @client.post('/api/vote', id: fullname, dir: direction)
        @attributes[:ups] += direction
      end
    end
  end
end
