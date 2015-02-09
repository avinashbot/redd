require_relative "base"

module Redd
  module Objects
    # A reddit thing.
    # @see http://www.reddit.com/dev/api#fullnames
    class Thing < Base
      # Load up all the possible mixins for the thing.
      Dir.glob("./thing/*.rb") { |file| require(file) }

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

      private

      def response_merge!(meth, path, params = {})
        body = client.send(meth, path, params).body
        deep_merge!(body[:data])
      end
    end
  end
end
