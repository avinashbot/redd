module Redd
  module Object
    # The model for a morecomments object
    class MoreComments < Redd::Base
      attr_reader :count
      attr_reader :parent_id
      attr_reader :children
    end
  end
end
