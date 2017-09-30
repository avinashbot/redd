# frozen_string_literal: true

require_relative 'model'

module Redd
  module Models
    # An enumerable type that covers listings and expands forwards.
    class PaginatedListing
      include Enumerable

      # Create an expandable listing.
      # @param caller [Proc] the proc to call to fetch the next listing
      # @param after [String] the fullname of the item after this listing
      # @param limit [Integer] the maximum number of items to fetch
      # @yieldparam after [String] the fullname of the item to fetch after
      # @yieldparam limit [Integer] the number of items to fetch (max 100)
      # @yieldreturn [Listing] the listing to return
      def initialize(after: nil, limit: nil, &block)
        raise ArgumentError, 'block must be provided' unless block_given?

        @caller = block
        @after = after
        @limit = limit || 1000
        @remaining = []
      end

      # @yield [Object] the object returned in the listings
      def each(&block)
        loop do
          return if @limit == 0
          @remaining = fetch_next_listing
          return if @remaining.children.empty? # if the fetched listing is empty
          @remaining.each(&block)
          return if @remaining.after.nil? # if there's no link to the next item
        end
      end

      private

      # Fetch the next listing with @caller and update @after and @limit.
      def fetch_next_listing
        caller_limit = [@limit, 100].min
        listing = @caller.call(@after, caller_limit)
        @after = listing.after
        @limit -= caller_limit
        listing
      end
    end
  end
end
