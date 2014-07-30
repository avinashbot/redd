require "forwardable"

module Redd
  module Object
    # A listing of various reddit things.
    # @see http://www.reddit.com/dev/api#listings
    # @see http://stackoverflow.com/a/2080118
    class Listing
      include Enumerable
      extend Forwardable
      def_delegators :@things, :[], :length, :size, :each, :map, :empty?

      # @!attribute [r] things
      # @return [Array] A list of things in the listing.
      attr_reader :things

      # Create a new listing with the given things.
      # @param [Array] things A list of things to generate a Listing out of.
      def initialize(things)
        @things = things
      end
    end
  end
end
