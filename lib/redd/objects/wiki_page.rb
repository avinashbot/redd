require_relative "thing"

module Redd
  module Objects
    # A submission made in a subreddit.
    class WikiPage < Thing
      alias_property :content, :content_md
      alias_property :body, :content_md

      def revision_user
        @revision_by ||= client.object_from_body(revision_by)
      end
    end
  end
end
