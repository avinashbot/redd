module Redd
  module Client
    class Unauthenticated
      module LinksComments
        # @note Reddit does accept a subreddit, but with fullnames and urls, I
        #   assumed that was unnecessary.
        def get_info(params = {})
          meth = :get
          path = "/api/info.json"
          object_from_response(meth, path, params)
        end
      end
    end
  end
end
