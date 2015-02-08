module Redd
  module Clients
    class Base
      module PrivateMessages
        def my_messages(category = "inbox", mark = false, params = {})
          params[:mark] = mark
          object_from_response(:get, "/message/#{category}.json", params)
        end
      end
    end
  end
end
