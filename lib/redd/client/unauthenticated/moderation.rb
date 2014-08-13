module Redd
  module Client
    class Unauthenticated
      # Methods that deal with subreddit styles
      module Moderation
        # @param subreddit [Redd::Object::Subreddit, String] The subreddit to
        #   query.
        # @return [String] The url for the subreddit's css stylesheet.
        def stylesheet_url(subreddit = nil)
          name = extract_attribute(subreddit, :display_name)
          path = "/stylesheet"
          path = path.prepend("/r/#{name}") if subreddit

          get(path).headers[:location]
        end

        # @param subreddit [Redd::Object::Subreddit, String] The subreddit to
        #   query.
        # @return [String] The css stylesheet for the subreddit.
        def stylesheet(subreddit = nil)
          get stylesheet_url(subreddit)
        end
      end
    end
  end
end
