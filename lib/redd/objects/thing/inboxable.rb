module Redd
  module Objects
    class Thing
      # Things that can be sent to a user's inbox.
      module Inboxable
        # Mark this thing as read.
        def mark_as_read
          post("/api/read_message", id: fullname)
        end

        # Mark one or more messages as unread.
        def mark_as_unread
          post("/api/unread_message", id: fullname)
        end

        # Reply to the thing.
        # @param text [String] The text to comment.
        # @return [Objects::Comment, Objects::PrivateMessage] The reply.
        def reply(text)
          client.add_comment(self, text)
        end
      end
    end
  end
end
