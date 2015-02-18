require_relative "base"

module Redd
  module Objects
    # A reddit thing.
    # @see http://www.reddit.com/dev/api#fullnames
    class Thing < Base
      # Load up all the possible mixins for the thing.
      Dir[File.join(File.dirname(__FILE__), "thing", "*.rb")].each do |file|
        require(file)
      end

      # Check for equality.
      # @param other The other object.
      # @return [Boolean]
      def ==(other)
        other.is_a?(Thing) && fullname == other.fullname
      end

      # @return [String] The fullname of the thing.
      def fullname
        self[:name] || "#{kind}_#{id}"
      end
    end
  end
end
