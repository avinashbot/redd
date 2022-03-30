# frozen_string_literal: true

require_relative 'model'

module Redd
  module Models
    # An enumerable type that covers listings and expands forwards.
    #
    # If you want to use the #[] operator, you'll need to convert the object to an Array. This can
    # be done with either {Enumerable#first} or {Enumerable#to_a}.
    class PaginatedListing
      include Enumerable

      # A simple fixed-size ring buffer.
      # @api private
      class RingBuffer
        def initialize(size)
          @size = size
          @backing_array = Array.new(size)
          @pointer = 0
        end

        def include?(el)
          @backing_array.include?(el)
        end

        def add(el)
          @backing_array[@pointer] = el
          @pointer = (@pointer + 1) % @size
        end
      end

      # Create an expandable listing.
      # @param client [APIClient] the caller to use for streams
      # @param options [Hash]
      # @option options [String] :before the listing's before parameter
      # @option options [String] :after the listing's after parameter
      # @option options [Integer] :limit the maximum number of items to fetch
      # @yieldparam after [String] the fullname of the item to fetch after
      # @yieldparam limit [Integer] the number of items to fetch (max 100)
      # @yieldreturn [Listing] the listing to return
      def initialize(client, **options, &block)
        raise ArgumentError, 'block must be provided' unless block_given?

        @client = client
        @caller = block
        @before = options[:before]
        @after = options[:after]
        @limit = options[:limit] || 1000
      end

      # Go forward through the listing.
      # @yield [Model] the object returned in the listings
      # @return [Enumerator] if a block wasn't provided
      def each(&block)
        return _each(&block) if block_given?

        enum_for(:_each)
      end

      # Stream through the listing.
      # @note If you iterate through the stream, you'll loop forever.
      #   This may or may not be desirable.
      # @yield [Model] the object returned in the listings
      # @return [Enumerator] if a block wasn't provided
      def stream(&block)
        return _stream(&block) if block_given?

        enum_for(:_stream)
      end

      private

      # Go backward through the listing.
      # @yield [Object] the object returned in the listings
      def _stream
        buffer = RingBuffer.new(100)
        remaining = @limit > 0 ? reverse_each.to_a : []

        loop do
          remaining.push(*fetch_prev_listing)
          remaining.reverse_each do |o|
            next if buffer.include?(o.id)

            buffer.add(o.id)
            yield o
          end
          remaining.clear
        end
      end

      # Go forward through the listing.
      # @yield [Object] the object returned in the listings
      def _each(&block)
        loop do
          return if @limit == 0

          remaining = fetch_next_listing
          return if remaining.children.empty? # if the fetched listing is empty

          remaining.each(&block)
          return if remaining.after.nil? # if there's no link to the next item
        end
      end

      # Fetch the next listing with @caller and update @after and @limit.
      def fetch_next_listing
        caller_limit = [@limit, 100].min
        listing = @caller.call(after: @after, limit: caller_limit)
        @after = listing.after
        @limit -= caller_limit
        listing
      end

      # Fetch the previous listing with @caller and update @before.
      def fetch_prev_listing
        # we're not using the user-provided because a stream isn't supposed to die
        listing = @caller.call(before: @before, after: nil, limit: 100)
        @before = listing.empty? ? nil : listing.first.name
        listing
      end
    end
  end
end
