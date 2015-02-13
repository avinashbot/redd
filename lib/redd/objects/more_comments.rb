module Redd
  module Objects
    # The model for a morecomments object
    class MoreComments < Array
      def initialize(_, attributes)
        super(attributes[:children])
      end
    end
  end
end
