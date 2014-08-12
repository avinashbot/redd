require "redd/thing"

module Redd
  class Thing
    # A Redd::Object that can be voted on
    module Voteable
      def upvote
        client.upvote(self)
      end

      def downvote
        client.upvote(self)
      end

      def unvote
        client.upvote(self)
      end

      alias_method :clear_vote, :unvote
    end
  end
end
