require_relative "thing"

module Redd
  module Objects
    # A submission made in a subreddit.
    class WikiPage < Thing
      alias_property :content, :content_md
      alias_property :body, :content_md

      def revision_by
        @revision_by ||= client.object_from_body(self[:revision_by])
      end

      def revision_date
        @created ||= Time.at(self[:revision_date])
      end
    end
  end
end
