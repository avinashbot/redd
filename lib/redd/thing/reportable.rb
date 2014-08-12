require "redd/thing"

module Redd
  class Thing
    # A Redd::Object that can be reported to the mods
    module Reportable
      def report
        client.report(self)
      end
    end
  end
end
