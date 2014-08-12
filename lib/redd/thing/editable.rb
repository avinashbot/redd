require "redd/thing"

module Redd
  class Thing
    # A Redd::Object that can be edited
    module Editable
      def delete
        client.delete(self)
      end

      def edit(text)
        client.edit(self, text)
      end
    end
  end
end
