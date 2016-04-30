module Redd
  module Objects
    # The model for a morecomments object
    class MoreComments < Array
      def initialize(_, attributes)
        #Return an empty arrar if there are no children
        super(attributes[:children]) if attributes[:children]
      end
    end
  end
end
