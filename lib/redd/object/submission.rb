require "redd/thing"

module Redd
  module Object
    # A submission made in a subreddit.
    class Submission < Redd::Thing
      # @!attribute [r] title
      # @return [String] The title of the submission.
      attr_reader :title

      # @!attribute [r] url
      # @return [String] The url the submission links to.
      attr_reader :url

      # @!attribute [r] num_comments
      # @return [Integer] The number of comments the submission has.
      attr_reader :num_comments

      # @!attribute [r] domain
      # @return [String] The domain the url belongs to.
      attr_reader :domain

      # @!attribute [r] subreddit
      # @return [String] The name of the subreddit this comment belongs to.
      # @todo Convert to a Subreddit object?
      attr_reader :subreddit

      # @!attribute [r] is_self?
      # @return [Boolean] Whether the submission is a self submission.
      attr_reader :self?, :is_self

      # @!attribute [r] thumbnail
      # @return [String] The url for the thumbnail of the submission.
      attr_reader :thumbnail
      alias_method :thumbnail_url, :thumbnail

      # @!attribute [r] selftext
      # @return [String] The text of the submission in markdown.
      # @note This returns "" if the submission is not a self submission.
      attr_reader :selftext

      # @!attribute [r] selftext_html
      # @return [String] The text of the submission in html.
      # @note This returns nil if the submission is not a self submission.
      # @note Be warned: this isn't actual html, but escaped html. So all the
      #   <'s and >'s are converted to &lt;'s and &gt;'s.
      attr_reader :selftext_html

      # @!attribute [r] link_flair_text
      # @return [String] The submission's flair.
      attr_reader :link_flair_text

      # @!attribute [r] link_flair_css_class
      # @return [String] The CSS class of the submission's flair.
      attr_reader :link_flair_css_class

      # @!attribute [r] author_flair_text
      # @return [String] The user's flair.
      attr_reader :author_flair_text

      # @!attribute [r] author_flair_css_class
      # @return [String] The CSS class of the user's flair.
      attr_reader :author_flair_css_class

      # @!attribute [r] clicked
      # @return [Boolean] Whether the user already clicked on the link before.
      # @note This only works for users with reddit gold.
      attr_reader :clicked

      # @!attribute [r] visited
      # @return [Boolean] Whether the user already visited on the link before.
      # @note I have no idea what the difference between this and {#clicked} is
      attr_reader :visited

      # @!attribute [r] stickied
      # @return [Boolean] Whether the submission was stickied in the subreddit.
      attr_reader :stickied

      # @!attribute [r] nsfw?
      # @return [Boolean] Whether the post is marked as NSFW.
      attr_reader :nsfw?, :over_18

      # @return [String] The full url to the post on reddit.com.
      def permalink
        "http://www.reddit.com" + attributes[:permalink]
      end

      # @return [String] The short url on redd.it.
      def short_url
        "http://redd.it/" + id
      end
    end
  end
end
