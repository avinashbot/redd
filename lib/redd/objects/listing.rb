module Redd
  module Objects
    # A collection of reddit things.
    # @see https://www.reddit.com/dev/api#listings
    class Listing < Array
      # @!attribute [r] before
      # @return [String] The id of the object before the listing.
      attr_reader :before

      # @!attribute [r] after
      # @return [String] The id of the object after the listing.
      attr_reader :after

      # @param [Clients::Base] client The client to expand the comments with.
      # @param [{:before => String, :after => String,
      #   :children => Array<Hash>}] attributes The data to initialize the
      #   class with.
      # @todo Only call Clients::Base#object_from_body when item is being
      #   accessed.
      def initialize(client, attributes)
        @before = attributes[:before]
        @after = attributes[:after]
        attributes[:children].each do |child|
          self << client.object_from_body(child) || child
        end
      end
    end
  end
end
