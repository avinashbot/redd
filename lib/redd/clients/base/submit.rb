module Redd
  module Clients
    class Base
      # Methods that require the "submit" scope
      module Submit
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
