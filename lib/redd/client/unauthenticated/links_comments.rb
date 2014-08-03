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

        def get_replies(comment)
          replies = comment.attributes[:replies]
          return [] unless replies.is_a?(Hash) and replies.has_key?(:kind)
          object_from_body(replies)
        end
      end
    end
  end
end
