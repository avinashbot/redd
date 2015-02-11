require "set"

module Redd
  module Clients
    class Base
      # Methods that stream delicious content into your bot's lazy mouth.
      module Stream
        # A class similar to PRAW's implementation of a BoundedSet.
        class PRAWBoundedQueueSet < Set
          def initialize(max, *args, &block)
            @max = max
            @queue = []
            super(*args, &block)
          end

          def enqueue(element)
            @queue.push(element) if add?(element)
            dequeue! if size > @max
            self
          end
          alias_method :enq, :enqueue

          def enqueue?(element)
            added = add?(element)
            if added
              @queue.push(element)
              dequeue if size > @max
            end
            added
          end
          alias_method :enq?, :enqueue?

          def dequeue
            element = @queue.shift
            delete(element)
            element
          end
          alias_method :deq, :dequeue
        end

        # Stream the results of a method call to the given block.
        # @param [Symbol] meth A method that returns a listing and has a
        #   keyword parameter named `:before`.
        # @param [Array] args The arguments supplied to the method.
        # @param [Hash] kwargs The keyword arguments supplied to the method.
        # @yield An element of the returned listing.
        def stream(meth = :get_new, *args, **kwargs)
          bset = PRAWBoundedQueueSet.new(10)
          before = ""
          loop do
            # Get the latest comments from the subreddit. By the way, this line
            # is the one where the sleeping/rate-limiting happens.
            params = kwargs.merge(before: before)
            listing = send(meth, *args, **params)
            # Run the loop for each of the item in the listing
            listing.reverse_each do |thing|
              yield thing if bset.enqueue?(thing.fullname)
            end
            # Set the latest comment.
            before = listing.first.fullname unless listing.empty?
          end
        end
      end
    end
  end
end
