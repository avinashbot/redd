# frozen_string_literal: true

require 'enumerator'

module Redd
  module Utilities
    # A forward-expading listing of items that can be enumerated forever.
    class Stream
      # A simple fixed-size ring buffer.
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

      # Create a streamer.
      # @yield [latest]
      # @yieldparam latest [String, nil] the fullname of the latest model requested
      # @yieldreturn [Listing] the models after the latest one
      def initialize(&block)
        @loader = block
        @buffer = RingBuffer.new(10)
        @latest = nil
      end

      # Make another request to reddit, yielding new elements.
      # @yield [element] an element from the listings returned by the loader
      def next_request
        # Get the elements from the loader before the `latest` element
        listing = @loader.call(@latest)
        # If there's nothing new to process, request again.
        return if listing.empty?
        # Set the latest element to the latest one to be processed.
        @latest = listing.first.name
        # Iterate over the new elements, oldest to newest.
        listing.reverse_each do |el|
          next if @buffer.include?(el.name)
          yield el
          @buffer.add(el.name)
        end
      end

      # Loop forever, yielding the elements from the loader
      # @yield [element] an element from the listings returned by the loader
      def stream
        loop do
          next_request { |el| yield el }
        end
      end
    end
  end
end
