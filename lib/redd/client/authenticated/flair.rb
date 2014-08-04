module Redd
  module Client
    class Authenticated
      module Flair
        def get_flair_list(subreddit = nil, params = {})
          name = extract_attribute(subreddit, :display_name) if subreddit

          path = "/api/flairlist.json"
          path = path.prepend("/r/#{name}") if name

          get(path, params)[:users]
        end

        # @see http://ruby-doc.org/core-1.9.3/String.html#method-i-casecmp
        def get_flair(user, subreddit = nil)
          username = extract_attribute(user, :name)
          options = {name: username}

          flair = get_flair_list(subreddit, options).first
          flair if flair[:user].casecmp(username.downcase) == 0
        end
      end
    end
  end
end
