module Redd
  module Client
    class Unauthenticated
      # Methods to interact with subreddit wikis
      module Wiki
        # Get a list of pages in the subreddit wiki.
        # @param subreddit [Redd::Object::Subreddit, String] The subreddit to
        #   look in.
        # @return [Array] An array of wikipage titles.
        def get_wikipages(subreddit = nil)
          name = extract_attribute(subreddit, :display_name)

          path = "/wiki/pages.json"
          path.prepend("/r/#{name}") if subreddit
          get(path)[:data]
        end

        # Get a wiki page.
        # @param page [String] The title of the wiki page.
        # @param subreddit [Redd::Object::Subreddit, String] The subreddit to
        #   look in.
        # @return [Redd::Object::WikiPage] A wiki page.
        def wikipage(page, subreddit = nil)
          name = extract_attribute(subreddit, :display_name)

          path = "/wiki/#{page}.json"
          path.prepend("/r/#{name}") if subreddit
          object_from_response :get, path
        end
      end
    end
  end
end
