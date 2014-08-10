require "redd/thing"

module Redd
  class Thing
    module Saveable
      def save(category = nil)
        client.save(self, category)
      end

      def unsave
        client.unsave(self)
      end
    end
  end
end
