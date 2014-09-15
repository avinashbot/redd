module Redd
  module Client
    class Unauthenticated
      module LinksComments
        # @param params [Hash] A hash of parameters to send to reddit.
        # @option params [String] :id The fullname of a thing.
        # @option params [String] :url The url of a thing. If an id is also
        #   provided, the id will take precedence.
        # @return [Redd::Object::Listing] Listing of the object or objects.
        #
        # @note Reddit does accept a subreddit, but with fullnames and urls, I
        #   assumed that was unnecessary.
        def get_info(params = {})
          object_from_response :get, "/api/info.json", params
        end

        # Get the comments for a submission.
        #
        # @param submission [String, Redd::Object::Submission] The submission
        #   to get the comments for.
        # @return [Redd::Object::Listing] A listing of comments.
        def submission_comments(submission)
          id = extract_id(submission)
          comments_from_response :get, "/comments/#{id}.json"
        end

        # Get the replies for a comment.
        #
        # @param comment [String, Redd::Object::Submission] The comment to get
        #   the replies for.
        # @return [Redd::Object::Listing] A listing of comments.
        def get_replies(comment)
          replies = comment.attributes[:replies]
          return [] unless replies.is_a?(Hash) && replies.key?(:kind)
          object_from_body(replies)
        end

        def expand_morecomments(morecomments, submission = nil)
          parent_id = morecomments.parent_id
          link_id =
            if submission
              extract_fullname(submission)
            elsif parent_id.start_with?("t3_")
              parent_id
            elsif parent_id.start_with?("t1_")
              get_info(id: parent_id).first.link_id
            end

          response = post "/api/morechildren.json",
                          api_type: "json",
                          link_id: link_id,
                          children: morecomments.children.join(",")
          comments = response[:json][:data][:things]

          object_from_body(kind: "Listing", data: {children: comments})
        end
      end
    end
  end
end
