require "redd/thing"

module Redd
  class Thing
    module Inboxable
      def mark_as_read
        client.mark_as_read(self)
      end

      def mark_as_unread
        client.mark_as_unread(self)
      end

      def reply(text)
        client.add_comment(self, text)
      end
    end
  end
end
