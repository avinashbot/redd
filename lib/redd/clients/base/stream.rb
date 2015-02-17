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

          # Add an element to the front if it isn't already in the queue.
          # @param element
          # @return [PRAWBoundedQueueSet] self
          def enqueue(element)
            @queue.push(element) if add?(element)
            dequeue! if size > @max
            self
          end
          alias_method :enq, :enqueue

          # Add an element to the front if it isn't already in the queue.
          # @param element
          # @return [Boolean] Whether the element was added to the queue.
          def enqueue?(element)
            added = add?(element)
            if added
              @queue.push(element)
              dequeue if size > @max
            end
            added
          end
          alias_method :enq?, :enqueue?

          # Remove the last element of the queue.
          # @return The removed element.
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
            begin
              # Get the latest comments from the subreddit.
              params = kwargs.merge(before: before)
              listing = send(meth, *args, **params)
              # Run the loop for each of the item in the listing
              listing.reverse_each do |thing|
                yield thing if bset.enqueue?(thing.fullname)
              end
              # Set the latest comment.
              before = listing.first.fullname unless listing.empty?
            rescue Redd::Error::RateLimited => error
              # If this error pops up, you probably have an issue with your bot.
              sleep(error.time)
            rescue Redd::Error => error
              # 5-something errors are usually errors on reddit's end.
              raise error unless (500...600).include?(error.code)
            end
          end
        end
      end # <- See, this is why I sometimes prefer Python.
    end # <- Thank god for code folding.
  end
end
