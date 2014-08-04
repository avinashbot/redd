module Redd
  module Client
    class Unauthenticated
      module Listing
        def by_id(*fullnames)
          names = fullnames.join(",")

          meth = :get
          path = "/by_id/#{names}.json"
          object_from_response(meth, path)
        end

        def get_hot(*args)
          get_listing(:hot, *args)
        end

        def get_new(*args)
          get_listing(:new, *args)
        end

        def get_random(*args)
          get_listing(:random, *args)
        end

        def get_top(*args)
          get_listing(:top, *args)
        end

        def get_controversial(*args)
          get_listing(:controversial, *args)
        end

        private

        def get_listing(type, subreddit = nil, params = {})
          subreddit_name = extract_attribute(subreddit, :display_name)

          meth = :get
          path = "/#{type}.json"
          path = path.prepend("/r/#{subreddit_name}") if subreddit_name

          object_from_response(meth, path, params)
        end
      end
    end
  end
end
