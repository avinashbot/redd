require_relative "thing"

module Redd
  module Objects
    # The model for private messages
    class PrivateMessage < Thing
      include Thing::Inboxable

      alias_property :from, :author
      alias_property :to, :dest

      # Block the sender of the message from sending any more.
      def block_sender!
        post("/api/block", id: fullname)
      end

      # Mark the message as read.
      def mark_as_read
        post("/api/read_message", id: fullname)
      end

      # Mark the message as unread and add orangered to account.
      def mark_as_unread
        post("/api/unread_message", id: fullname)
      end
    end
  end
end
