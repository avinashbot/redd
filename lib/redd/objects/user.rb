require_relative "thing"

module Redd
  module Objects
    # The model for a reddit user
    class User < Thing
      alias_property :has_gold?, :is_gold

      def self.from_name(name)
        merge_response! :get, "/api/v1/me"
      end
    end
  end
end
