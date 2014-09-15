module Redd
  module Object
    # The model for a morecomments object
    class MoreComments < Redd::Base
      attr_reader :count
      attr_reader :parent_id
      attr_reader :children

      def expand(submission = nil)
        client.expand_morecomments(self, submission)
      end
    end
  end
end
