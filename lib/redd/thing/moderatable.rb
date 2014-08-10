require "redd/thing"

module Redd
  class Thing
    module Moderatable
      def approve
        client.approve(self)
      end

      def remove
        client.remove(self)
      end

      def distinguish(how = :yes)
        client.distinguish(self, how)
      end

      def undistinguish
        client.undistinguish(self)
      end

      def ignore_reports
        client.ignore_reports(self)
      end

      def unignore_reports
        client.unignore_reports(self)
      end
    end
  end
end
