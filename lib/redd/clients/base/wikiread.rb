module Redd
  module Clients
    class Base
      # Methods that require the "wikiread" scope
      module Wikiread
        # Get a list of pages in the subreddit wiki.
        # @param subreddit [Objects::Subreddit, String] The subreddit to
        #   look in.
        # @return [Array<String>] An array of wikipage titles.
        def get_wikipages(subreddit = nil)
          name = property(subreddit, :display_name)

          path = "/wiki/pages.json"
          path.prepend("/r/#{name}") if subreddit
          get(path)[:data]
        end

        # Get a wiki page.
        # @param page [String] The title of the wiki page.
        # @param subreddit [Objects::Subreddit, String] The subreddit to
        #   look in.
        # @return [Objects::WikiPage] A wiki page.
        def wikipage(page, subreddit = nil)
          name = property(subreddit, :display_name)

          path = "/wiki/#{page}.json"
          path.prepend("/r/#{name}") if subreddit
          object_from_response :get, path
        end
      end
    end
  end
end
