module Redd
  module Client
    class Authenticated
      module Moderation
        def approve(thing)
          fullname = extract_fullname(thing)

          meth = :post
          path = "/api/approve"
          params = {id: fullname}

          send(meth, path, params)
        end

        def remove(thing)
          fullname = extract_fullname(thing)

          meth = :post
          path = "/api/remove"
          params = {id: fullname}

          send(meth, path, params)
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

        def get_submissions(type, subreddit = nil, options = {})
          subreddit_name = extract_attribute(subreddit, :display_name)

          meth = :get
          path = "/about/#{type}.json"
          path = path.prepend("/r/#{subreddit_name}") if subreddit_name

          object_from_response(meth, path, params)
        end
      end
    end
  end
end
