module Redd
  module Client
    class Unauthenticated
      module LinksComments
        # @note Reddit does accept a subreddit, but with fullnames and urls, I
        #   assumed that was unnecessary.
        def get_info(params = {})
          object_from_response :get, "/api/info.json"
        end

        def get_comments(submission)
          id = extract_id(submission)
          comments_from_response :get, "/comments/#{id}.json"
        end

        def get_replies(comment)
          replies = comment.attributes[:replies]
          return [] unless replies.is_a?(Hash) and replies.has_key?(:kind)
          object_from_body(replies)
        end

        # FIX THIS ASAP
        def replace_morecomments(morecomments)
          parent_id = morecomments.parent_id
          link_id = 
            if parent_id.start_with?("t1_")
              get_info(id: parent_id).first.link_id
            elsif parent_id.start_with?("t3_")
              parent_id
            end

          meth = :post
          path = "/api/morechildren"
          params = {
            api_type: "json", link_id: link_id,
            children: morecomments.children.join(",")
          }

          send(meth, path, params)
        end
      end
    end
  end
end
