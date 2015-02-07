require_relative "thing"

module Redd
  module Objects
    # The model for a reddit user
    class User < Thing
      alias_property :has_gold?, :is_gold
    end
  end
end
