module Redd
  module Client
    class Unauthenticated
      # Methods that return a listing
      module Listing
        def by_id(*fullnames)
          names = fullnames.join(",")
          object_from_response :get,  "/by_id/#{names}.json"
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

        def get_comments(*args)
          get_listing(:comments, *args)
        end

        private

        def get_listing(type, subreddit = nil, params = {})
          name = extract_attribute(subreddit, :display_name) if subreddit

          path = "/#{type}.json"
          path = path.prepend("/r/#{name}") if name

          object_from_response :get, path, params
        end
      end
    end
  end
end
