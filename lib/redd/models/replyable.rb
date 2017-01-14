# frozen_string_literal: true

module Redd
  module Models
    # A model that can be commented on or replied to.
    module Replyable
      # Add a comment to a link, reply to a comment or reply to a message.
      # @param text [String] the text to comment
      # @return [Comment, PrivateMessage] The created reply.
      def reply(text)
        fullname = get_attribute(:name)
        @client.model(:post, '/api/comment/', text: text, thing_id: fullname).first
      end
    end
  end
end
