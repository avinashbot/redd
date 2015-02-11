module Redd
  module Objects
    # A collection of reddit things.
    # @see https://www.reddit.com/dev/api#listings
    class Listing < Array
      KIND = "Listing".freeze

      # @!attribute [r] before
      # @return [String] The id of the object before the listing.
      attr_reader :before

      # @!attribute [r] after
      # @return [String] The id of the object after the listing.
      attr_reader :after

      def initialize(client, data)
        data[:children].each do |child|
          self << client.object_from_body(child)
        end
        @before = data[:before]
        @after = data[:after]
      end

      def kind
        KIND
      end
    end
  end
end
