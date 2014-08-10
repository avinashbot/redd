require "redd/thing"

module Redd
  class Thing
    module Editable
      def delete
        client.delete(self)
      end

      def edit(text)
        client.edit(self, text)
    end
  end
end
