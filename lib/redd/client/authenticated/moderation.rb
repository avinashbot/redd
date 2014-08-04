module Redd
  module Client
    class Authenticated
      module Moderation
        def approve(thing)
          fullname = extract_fullname(thing)
          post "/api/approve", id: fullname
        end

        def remove(thing)
          fullname = extract_fullname(thing)
          post "/api/remove", id: fullname
        end

        def distinguish(thing, how = :yes)
          fullname = extract_fullname(thing)
          post "/api/distinguish", api_type: "json", id: fullname, how: how
        end

        def undistinguish(thing)
          distinguish(thing, :no)
        end

        def accept_moderator_invite(subreddit)
          name = extract_attribute(subreddit, :display_name)
          post "/r/#{name}/api/accept_moderator_invite", api_type: "json"
        end

        def leave_contributor_status(subreddit)
          fullname = extract_fullname(subreddit)
          post "/api/leavecontributor", id: fullname
        end

        def leave_moderator_status(subreddit)
          fullname = extract_fullname(subreddit)
          post "/api/leavemoderator", id: fullname
        end

        def ignore_reports(thing)
          fullname = extract_fullname(subreddit)
          post "/api/ignore_reports", id: fullname
        end

        def unignore_reports(thing)
          fullname = extract_fullname(subreddit)
          post "/api/unignore_reports", id: fullname
        end

        def get_reports(*args)
          get_submissions(:reports, *args)
        end

        def get_spam(*args)
          get_submissions(:spam, *args)
        end

        def get_modqueue(*args)
          get_submissions(:modqueue, *args)
        end

        def get_unmoderated(*args)
          get_submissions(:unmoderated, *args)
        end

        private

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
