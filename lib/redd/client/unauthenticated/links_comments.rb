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

        def get_comments(submission)
          id = extract_id(submission)

          meth = :get
          path = "/comments/#{id}.json"
          comments_from_response(meth, path)
        end
      end
    end
  end
end
