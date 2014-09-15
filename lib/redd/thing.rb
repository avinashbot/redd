require "redd/base"

module Redd
  # A reddit thing.
  # @see http://www.reddit.com/dev/api#fullnames
  class Thing < Redd::Base
    # @!attribute [r] id
    # @return [String] The id value for the thing.
    attr_reader :id

    # @!attribute [r] kind
    # @return [String] The kind of the thing.
    attr_reader :kind

    # Check for equality.
    # @param other The other object.
    # @return [Boolean]
    def ==(other)
      other.is_a?(Redd::Thing) && full_name == other.full_name
    end

    # @return [String] The fullname of the thing.
    def fullname
      @fullname ||= "#{kind}_#{id}"
    end
  end
end
