module Redd
  module Clients
    class Base
      module Read
        # @param [String] name The username.
        # @return [Objects::User] The user.
        def user_from_name(name)
          request_object(:get, "/user/#{name}/about.json")
        end

        # @param [String] name The subreddit's display name.
        # @return [Objects::Subreddit] The subreddit if found.
        def subreddit_from_name(name)
          request_object(:get, "/r/#{name}/about.json")
        end
      end
    end
  end
end
