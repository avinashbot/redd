require "redd/thing"

module Redd
  class Thing
    # A Redd::Object that can be hidden
    module Hideable
      def hide
        client.hide(self)
      end

      def unhide
        client.unhide(self)
      end
    end
  end
end
