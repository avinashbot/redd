module Redd
  module Client
    class Authenticated
      # Methods to deal with comments and links
      module LinksComments
        # Submit a link or a text post to a subreddit.
        #
        # @param title [String] The title of the submission.
        # @param kind [:self, :link] The type of submission to make.
        # @param text_or_url [String] The url of the post if :link or the
        #   content of the post if :text
        # @param subreddit [Redd::Object::Submission, String] The subreddit
        #   to submit to.
        # @param captcha [String] A possible captcha result to send if one
        #   is required.
        # @param identifier [String] The identifier for the captcha if one
        #   is required.
        # @param options [Hash] A hash of additional options to send.
        # @option options [Boolean] :resubmit (false) Whether to post a link
        #   to a subreddit despite it having been posted there before.
        # @option options [Boolean] :resubmit (false) Whether to automatically
        #   save the post to the user's account after posting.
        def submit(
          title, kind, text_or_url, subreddit, captcha = nil, identifier = nil,
          options = {}
        )

          params = {
            api_type: "json", extension: "json", title: title, kind: kind
          }
          sr_name = extract_attribute(subreddit, :display_name)
          params << {sr: sr_name}

          case kind.to_sym
          when :self
            params[:text] = text_or_url
          when :link
            params[:url] = text_or_url
          end

          params << {captcha: captcha, iden: identifier} if captcha
          params << options

          post "/api/submit", params
        end

        # Add a comment to a link, reply to a comment or reply to a message.
        # Bit of an all-purpose method, this one.
        #
        # @param thing [Redd::Object::Submission, Redd::Object::Comment,
        #   Redd::Object::PrivateMessage, String] A thing to add a comment to.
        # @param text [String] The text to comment.
        def add_comment(thing, text)
          fullname = extract_fullname(thing)
          post "/api/comment", api_type: "json", text: text, thing_id: fullname
        end

        alias_method :reply, :add_comment

        # Delete a thing.
        #
        # @param thing [Redd::Object::Submission, Redd::Object::Comment,
        #   String] A thing to delete.
        def delete(thing)
          fullname = extract_fullname(thing)
          post "/api/del", id: fullname
        end

        # Edit a thing.
        #
        # @param thing [Redd::Object::Submission, Redd::Object::Comment,
        #   String] A thing to delete.
        # @param text [String] The new text.
        def edit(thing, text)
          fullname = extract_fullname(thing)
          post "/api/editusertext", api_type: "json",
                                    thing_id: fullname,
                                    text: text
        end

        # Hide a link from the logged-in user.
        #
        # @param thing [Redd::Object::Submission, String] A link to hide.
        def hide(thing)
          fullname = extract_fullname(thing)
          post "/api/hide", id: fullname
        end

        # Unhide a previously hidden link.
        #
        # @param thing [Redd::Object::Submission, String] A link to show.
        def unhide(thing)
          fullname = extract_fullname(thing)
          post "/api/unhide", id: fullname
        end

        # Mark a link as "NSFW" (Not Suitable For Work)
        #
        # @param thing [Redd::Object::Submission, String] A link to mark.
        def mark_as_nsfw(thing)
          fullname = extract_fullname(thing)
          post "/api/marknsfw", id: fullname
        end

        # Remove the NSFW label from the link.
        #
        # @param thing [Redd::Object::Submission, String] A link to mark.
        def unmark_as_nsfw(thing)
          fullname = extract_fullname(thing)
          post "/api/unmarknsfw", id: fullname
        end

        alias_method :mark_as_safe, :unmark_as_nsfw

        # Report the link or comment to the subreddit moderators.
        #
        # @param thing [Redd::Object::Submission, Redd::Object::Comment,
        #   String] A link to report.
        def report(thing)
          fullname = extract_fullname(thing)
          post "/api/report", id: fullname
        end

        # Save a link or comment (if gilded) to the user's account.
        #
        # @param thing [Redd::Object::Submission, Redd::Object::Comment,
        #   String] A link to save.
        # @param category [String] A category to save to (if gilded).
        def save(thing, category = nil)
          fullname = extract_fullname(thing)
          params = {id: fullname}
          params << {category: category} if category
          post "/api/save", params
        end

        # Remove the link or comment from the user's saved links.
        #
        # @param thing [Redd::Object::Submission, Redd::Object::Comment,
        #   String] A link to unsave.
        def unsave(thing)
          fullname = extract_fullname(thing)
          post "/api/unsave", id: fullname
        end

        # Upvote the thing.
        #
        # @param thing [Redd::Object::Submission, Redd::Object::Comment,
        #   String] A link or comment to upvote.
        # @see #vote
        def upvote(thing)
          vote(thing, 1)
        end

        # Downvote the thing.
        #
        # @param thing [Redd::Object::Submission, Redd::Object::Comment,
        #   String] A link or comment to downvote.
        # @see #vote
        def downvote(thing)
          vote(thing, -1)
        end

        # Clear the user's vote on the thing.
        #
        # @param thing [Redd::Object::Submission, Redd::Object::Comment,
        #   String] A link or comment to remove the vote on.
        # @see #vote
        def unvote(thing)
          vote(thing, 0)
        end

        alias_method :clear_vote, :unvote

        private

        # Set a vote on the thing.
        #
        # @param thing [Redd::Object::Submission, Redd::Object::Comment,
        #   String] A link or comment to set a vote on.
        # @note Votes must be cast by humans only! Your script can proxy a
        #   user's actions, but it cannot decide what to vote.
        def vote(thing, direction)
          fullname = extract_fullname(thing)
          post "/api/vote", id: fullname, dir: direction
        end
      end
    end
  end
end
