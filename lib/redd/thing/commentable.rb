require "redd/thing"

module Redd
  class Thing
    # A Redd::Object that can be commented on.
    # This means that the comments could contain a MoreComments object.
    module Commentable
      def expand_morecomments
        comments.things.map! do |comment|
          if comment.is_a?(Redd::Object::MoreComments)
            comment.expand.things
          else
            comment
          end
        end

        comments.things.flatten!
      end

      def remove_morecomments
        while comments.map { |c| c.class }.include? Redd::Object::MoreComments
          expand_morecomments
        end
      end
    end
  end
end
