require_relative "thing"

module Redd
  module Objects
    # The model for private messages
    class PrivateMessage < Thing
      # include Inboxable

      alias_property :from, :author
      alias_property :to, :dest
    end
  end
end
