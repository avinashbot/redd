module Redd
  module Objects
    # The model for a morecomments object
    class MoreComments < Array
      KIND = "more".freeze

      # @!attribute [r] parent_id
      # @return [String] The id of the parent comment or the link.
      attr_reader :parent_id

      # @!attribute [r] link_id
      # @return [String] The id of the link, which is necessary to expand the
      #   object.
      # @note The id isn't provided by reddit, so the client should take care
      #   of adding this.
      attr_reader :link_id

      def initialize(client, data, link_id = "")
        fail NotImplementedError
      end

      def kind
        KIND
      end
    end
  end
end
