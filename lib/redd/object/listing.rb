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

      attr_reader :kind
      attr_reader :after
      attr_reader :before

      def initialize(listing)
        @kind = listing[:kind]
        @things = listing[:data][:children]
        @after = listing[:data][:after]
        @before = listing[:data][:before]
      end
    end
  end
end
