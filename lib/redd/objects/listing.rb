module Redd
  module Objects
    # A collection of reddit things.
    # @see https://www.reddit.com/dev/api#listings
    class Listing < Array
      KIND = "Listing"

      # @!attribute [r] before
      # @return [String] The id of the object before the listing.
      attr_reader :before

      # @!attribute [r] after
      # @return [String] The id of the object after the listing.
      attr_reader :after

      # @param [Array] children The contents of the array.
      # @param [String] before
      # @param [String] after
      def initialize(children = [], before: nil, after: nil)
        concat(children)
        @before = before
        @after = after
      end

      def kind
        KIND
      end
    end
  end
end
