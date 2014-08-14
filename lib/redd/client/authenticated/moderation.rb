module Redd
  module Client
    class Authenticated
      # Methods for moderating subreddits
      module Moderation
        # Approve a submission.
        # @param thing [Redd::Object::Submission] The link to approve.
        def approve(thing)
          fullname = extract_fullname(thing)
          post "/api/approve", id: fullname
        end

        # Remove a submission.
        # @param thing [Redd::Object::Submission] The link to remove.
        def remove(thing)
          fullname = extract_fullname(thing)
          post "/api/remove", id: fullname
        end

        # Distinguish a link or comment with a sigil to show that it has
        # been created by a moderator.
        #
        # @param thing [Redd::Object::Submission, Redd::Object::Comment]
        #   The link or comment to distinguish.
        # @param how [:yes, :no, :admin, :special] How to distinguish the
        #   thing.
        def distinguish(thing, how = :yes)
          fullname = extract_fullname(thing)
          post "/api/distinguish", api_type: "json", id: fullname, how: how
        end

        # Remove the sigil that shows a thing was created by a moderator.
        # @param thing [Redd::Object::Submission, Redd::Object::Comment]
        #   The link or comment to undistinguish.
        def undistinguish(thing)
          distinguish(thing, :no)
        end

        # Accept a moderator invite from a subreddit.
        # @param subreddit [Redd::Object::Subreddit] The subreddit to accept
        #   the invitation from.
        def accept_moderator_invite(subreddit)
          name = extract_attribute(subreddit, :display_name)
          post "/r/#{name}/api/accept_moderator_invite", api_type: "json"
        end

        # Stop being a contributor of the subreddit.
        # @param subreddit [Redd::Object::Subreddit] The subreddit to stop
        #   being a contributor of.
        def leave_contributor_status(subreddit)
          fullname = extract_fullname(subreddit)
          post "/api/leavecontributor", id: fullname
        end

        # Stop being a moderator of the subreddit.
        # @param subreddit [Redd::Object::Subreddit] The subreddit to stop
        #   being a moderator of.
        def leave_moderator_status(subreddit)
          fullname = extract_fullname(subreddit)
          post "/api/leavemoderator", id: fullname
        end

        # Stop getting any moderator-related reports on the thing.
        # @param thing [Redd::Object::Submission, Redd::Object::Comment]
        #   The thing to stop getting reports on.
        def ignore_reports(thing)
          fullname = extract_fullname(thing)
          post "/api/ignore_reports", id: fullname
        end

        # Start getting moderator-related reports on the thing again.
        # @param thing [Redd::Object::Submission, Redd::Object::Comment]
        #   The thing to start getting reports on.
        def unignore_reports(thing)
          fullname = extract_fullname(thing)
          post "/api/unignore_reports", id: fullname
        end

        # @!method get_reports
        # @!method get_spam
        # @!method get_modqueue
        # @!method get_unmoderated
        #
        # Get the appropriate listing.
        # @param subreddit [Redd::Object::Subreddit] The subreddit to query.
        # @param params [Hash] A list of params to send with the request.
        #
        # @see #get_submissions
        %w(reports spam modqueue unmoderated).each do |sort|
          define_method :"get_#{sort}" do |subreddit = nil, params = {}|
            get_submissions(sort, subreddit, params)
          end
        end

        private

        # Get a listing to moderator-related subreddits.
        #
        # @param type [:reports, :spam, :modqueue, :unmoderated] How the
        #   results are sorted.
        # @param subreddit [Redd::Object::Subreddit, String] The subreddit to
        #   query.
        # @param params [Hash] A list of params to send with the request.
        # @option params [String] :after Return results after the given
        #   fullname.
        # @option params [String] :before Return results before the given
        #   fullname.
        # @option params [Integer] :count (0) The number of items already seen
        #   in the listing.
        # @option params [1..100] :limit (25) The maximum number of things to
        #   return.
        # @option params :location No idea what this does.
        # @option params [:links, :comments] :only The type of things to show.
        # @return [Redd::Object::Listing] A listing of submissions or comments.
        #
        def get_submissions(type, subreddit = nil, params = {})
          subreddit_name = extract_attribute(subreddit, :display_name)
          path = "/about/#{type}.json"
          path = path.prepend("/r/#{subreddit_name}") if subreddit_name

          object_from_response :get, path, params
        end
      end
    end
  end
end
