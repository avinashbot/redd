# frozen_string_literal: true

module Redd
  module Models
    # Things that can be sent to a user's inbox.
    module Inboxable
      # Mark this thing as read.
      def mark_as_read
        @client.post('/api/read_message', id: get_attribute(:fullname))
      end

      # Mark one or more messages as unread.
      def mark_as_unread
        @client.post('/api/unread_message', id: get_attribute(:fullname))
      end
    end
  end
end
