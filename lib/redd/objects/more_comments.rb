module Redd
  module Objects
    # The model for a morecomments object
    class MoreComments < Array
      KIND = "more"

      # @!attribute [r] count
      # @return [Integer] The number of children to the comment. This would
      #   normally be the size of the children array, but there might be more
      #   comments generated before expansion or they aren't shown.
      attr_reader :count

      # @!attribute [r] parent_id
      # @return [String] The id of the parent comment or the link.
      attr_reader :parent_id

      # @!attribute [r] link_id
      # @return [String] The id of the link, which is necessary to expand the
      #   object.
      # @note The id isn't provided by reddit, so the client should take care
      #   of adding this.
      attr_reader :link_id

      def initialize(
        client, children = [],
        count: children.size, parent_id: nil, link_id: nil
      )
        concat(children)
        @client = client
        @count = count
        @parent_id = parent_id
        @link_id = link_id
      end

      def kind
        KIND
      end
    end
  end
end
