module Redd
  module Client
    class Unauthenticated
      # Methods that deal with subreddit styles
      module Moderation

        # @param subreddit [Redd::Object::Subreddit, String] The subreddit to
        #   query.
        # @return [String] The url for the subreddit's css stylesheet.
        def stylesheet(subreddit = nil)
          name = extract_attribute(subreddit, :display_name)
          path = "/stylesheet"
          path = path.prepend("/r/#{name}") if subreddit

          get(path)
        end

      end
    end
  end
end
