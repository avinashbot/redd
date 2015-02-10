module Redd
  module Objects
    class Thing
      # Things that can be voted upon.
      module Votable
        # Upvote the thing.
        def upvote
          vote(1)
        end

        # Downvote the thing.
        def downvote
          vote(-1)
        end

        # Remove your vote on the thing.
        def clear_vote
          vote(0)
        end
        alias_method :unvote, :clear_vote

        private

        # Send a vote.
        # @param [-1, 0, 1] direction The direction to vote in.
        def vote(direction)
          post("/api/vote", id: fullname, dir: direction)
          self[:ups] += direction
        end
      end
    end
  end
end
