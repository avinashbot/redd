require "redd/thing"

module Redd
  class Thing
    module Reportable
      def report
        client.report(self)
      end
    end
  end
end
