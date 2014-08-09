require "redd/base"

module Redd
  module Object
    # A submission made in a subreddit.
    class WikiPage < Redd::Base
      attr_reader :kind
      attr_reader :may_revise
      attr_reader :content_md
      attr_reader :content_html

      alias_method :content, :content_md
      alias_method :body, :content_md

      # HACK
      def revision_by
        @revision_by ||= client.send(
          :object_from_body, @attributes[:revision_by]
        )
      end

      def revision_date
        @created ||= Time.at(@attributes[:revision_date])
      end
    end
  end
end
