module Redd
  module Clients
    class Base
      # Methods that require the "submit" scope
      module Submit
        # Submit a link or a text post to a subreddit.
        #
        # @param [Objects::Submission, String] subreddit The subreddit
        #   to submit to.
        # @param [String] title The title of the submission.
        # @param [String] captcha A possible captcha result to send if one
        #   is required.
        # @param [String] identifier The identifier for the captcha if one
        #   is required.
        # @param [String] text The text of the self-post.
        # @param [String] url The URL of the link.
        # @param [Boolean] resubmit Whether to post a link to a subreddit
        #   despite it having been posted there before (you monster).
        # @param [Boolean] sendreplies Whether to send the replies to your
        #   inbox.
        # @return [Objects::Thing] The returned result (url, id and name).
        def submit(
          subreddit, title, captcha = nil, identifier = nil, text: nil,
          url: nil, resubmit: false, sendreplies: true
        )

          params = {
            extension: "json", title: title,
            resubmit: resubmit, sendreplies: sendreplies,
            sr: property(subreddit, :display_name)
          }

          params << {captcha: captcha, iden: identifier} if captcha
          params[:kind], params[:text] = :self, text if text
          params[:kind], params[:url] = :link, url if url

          response = post("/api/submit", params)
          Objects::Thing.new(self, response.body)
        end

        # Add a comment to a link, reply to a comment or reply to a message.
        # Bit of an all-purpose method, this one.
        # @param thing [Objects::Submission, Objects::Comment,
        #   Objects::PrivateMessage] A thing to add a comment to.
        # @param text [String] The text to comment.
        # @return [Objects::Comment, Objects::PrivateMessage] The reply.
        def add_comment(thing, text)
          response = post("/api/comment", text: text, thing_id: thing.fullname)
          object_from_body(response.body[:json][:data][:things][0])
        end
      end
    end
  end
end
