module Redd
  module Objects
    # A comment that can be made on a link.
    class LabeledMulti < Base
      # @see Objects::Base
      def initialize(client, attributes = {})
        attr_dup = attributes.dup
        attr_dup[:subreddits].map! { |sub| sub[:name] }
        super(client, attr_dup)
      end
    end
  end
end
