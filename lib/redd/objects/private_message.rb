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
    end
  end
end
