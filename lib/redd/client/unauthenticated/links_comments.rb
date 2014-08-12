module Redd
  module Client
    class Unauthenticated
      module LinksComments
        # @note Reddit does accept a subreddit, but with fullnames and urls, I
        #   assumed that was unnecessary.
        def get_info(params = {})
          object_from_response :get, "/api/info.json", params
        end

        def submission_comments(submission)
          id = extract_id(submission)
          comments_from_response :get, "/comments/#{id}.json"
        end

        def get_replies(comment)
          replies = comment.attributes[:replies]
          return [] unless replies.is_a?(Hash) && replies.key?(:kind)
          object_from_body(replies)
        end

        def replace_morecomments(morecomments, submission = nil)
          parent_id = morecomments.parent_id
          link_id =
            if submission
              submission
            elsif parent_id.start_with?("t3_")
              parent_id
            elsif parent_id.start_with?("t1_")
              get_info(id: parent_id).first.link_id
            end

          response = post "/api/morechildren",
                          api_type: "json",
                          link_id: link_id,
                          children: morecomments.children.join(",")
          comments = response[:json][:data][:things]

          # No idea how to increase the depth of the comments.
          comments.select! { |comment| comment[:kind] == "t1" }

          comments.map do |comment|
            object_from_body(
              kind: comment[:kind],
              data: {
                parent_id: comment[:data][:parent],
                body: comment[:data][:contentText],
                body_html: comment[:data][:contentHTML],
                link_id: comment[:data][:link],
                name: comment[:data][:id]
              }
            )
          end
        end
      end
    end
  end
end
