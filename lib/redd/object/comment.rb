require "redd/thing"

module Redd
  module Object
    # A comment made on links.
    class Comment < Redd::Thing
      # @!attribute [r] subreddit
      # @return [String] The name of the subreddit this comment belongs to.
      # @todo Convert to a Subreddit object?
      attr_reader :subreddit

      # @!attribute [r] parent_id
      # @return [String] The id of the parent comment.
      # @todo parent - get the parent comment directly.
      attr_reader :parent_id

      # @!attribute [r] body
      # @return [String] The text of the comment in markdown.
      attr_reader :body

      # @!attribute [r] body_html
      # @return [String] The text of the comment in html.
      # @note Be warned: this isn't actual html, but escaped html. So all the
      #   <'s and >'s are converted to &lt;'s and &gt;'s.
      attr_reader :body_html

      # @!attribute [r] author_flair_text
      # @return [String] The user's flair.
      attr_reader :author_flair_text

      # @!attribute [r] author_flair_css_class
      # @return [String] The CSS class of the user's flair.
      attr_reader :author_flair_css_class

      # @return [Boolean] Whether the comment is a root rather than a reply.
      def root?
        !parent_id || parent_id == fullname
      end
    end
  end
end
