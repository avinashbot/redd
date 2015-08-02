module Redd
  module Clients
    class Base
      # Methods that require the "privatemessages" scope
      module Privatemessages
        # Return a listing of a user's private messages.
        #
        # @param category ["inbox", "unread", "sent","moderator"] The category of messages
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
          request_object(:get, "/message/#{category}.json", params)
        end
		
		# Returns a listing of a subreddit's modmail if user has access.
		#
		# @param subreddit [String] The subreddit whos modmail to access
		# @param mark [Boolean] Whether to remove the orangered from the
        #   user's inbox.
		# @option params [String] :after Return results after the given
        #   fullname.
        # @option params [String] :before Return results before the given
        #   fullname.
        # @option params [Integer] :count (0) The number of items already seen
        #   in the listing.
        # @option params [1..100] :limit (25) The maximum number of things to
        #   return.
		def subreddit_modmail(subreddit,mark=false,params={})
			params[:mark]=mark
			request_object(:get,"/r/#{subreddit}/about/message/inbox.json",params)
		end
        
		# Mark all messages as read.
        def read_all_messages
          post("/api/read_all_messages")
        end
      end
    end
  end
end
