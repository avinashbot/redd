module Redd
  module Clients
    class Base
      module Privatemessages
        # Return a listing of a user's private messages.
        #
        # @param category ["inbox", "unread", "sent"] The category of messages
        #   to view.
        # @param mark [Boolean] Whether to remove the orangered from the
        #   user's inbox.
        # @param params [Hash] A list of params to send with the request.
        # @option params [String] :after Return results after the given
        #   fullname.
        # @option params [String] :before Return results before the given
        #   fullname.
        # @option params [Integer] :count (0) The number of items already seen
        #   in the listing.
        # @option params [1..100] :limit (25) The maximum number of things to
        #   return.
        def my_messages(category = "inbox", mark = false, params = {})
          params[:mark] = mark
          object_from_response(:get, "/message/#{category}.json", params)
        end
      end
    end
  end
end
