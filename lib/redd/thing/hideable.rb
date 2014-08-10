require "redd/thing"

module Redd
  class Thing
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
