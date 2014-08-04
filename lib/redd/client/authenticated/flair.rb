module Redd
  module Client
    class Authenticated
      module Flair
        def get_flair_list(subreddit = nil, options = {})
          name = extract_attribute(subreddit, :display_name) if subreddit

          meth = :get
          path = "/api/flairlist.json"
          path = path.prepend("/r/#{name}") if name
          params = options

          send(meth, path, params).body[:users]
        end

        def get_flair(user, subreddit = nil)
          username = extract_attribute(user, :name)
          options = {name: username}

          flair = get_flair_list(subreddit, options)[0]
          flair if flair[:user].downcase === username.downcase
        end
      end
    end
  end
end
