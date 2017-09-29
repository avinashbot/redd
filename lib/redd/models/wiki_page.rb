# frozen_string_literal: true

require_relative 'model'

module Redd
  module Models
    # A reddit user.
    class WikiPage < Model
      # Edit the wiki page.
      # @param content [String] the new wiki page contents
      # @param reason [String, nil] an optional reason for editing the page
      def edit(content, reason: nil)
        params = { page: read_attribute(:title), content: content }
        params[:reason] = reason if reason
        client.post("/r/#{read_attribute(:subreddit).display_name}/api/wiki/edit", params)
      end

      # @!attribute [r] title
      #   @return [String] the page title
      property :title, :required

      # @!attribute [r] subreddit
      #   @return [Subreddit] the wiki page's (optional) subreddit
      property :subreddit, :nil

      # @!attribute [r] may_revise?
      #   @return [Boolean] not sure, whether you're allowed to edit the page?
      property :may_revise?, from: :may_revise

      # @!attribute [r] revision_date
      #   @return [Time] the time of the last revision
      property :revision_date, with: ->(t) { Time.at(t) }

      # @!attribute [r] content_md
      #   @return [String] the markdown version of the content
      property :content_md

      # @!attribute [r] content_html
      #   @return [String] the html version of the content
      property :content_html

      # @!attribute [r] revision_by
      #   @return [User] the user who made the last revision
      property :revision_by, with: ->(res) { User.new(client, res[:data]) }

      private

      def lazer_reload
        fully_loaded!
        path = "/wiki/#{read_attribute(:title)}"
        path = "/r/#{read_attribute(:subreddit).display_name}#{path}" if self[:subreddit]
        client.get(path).body[:data]
      end
    end
  end
end
