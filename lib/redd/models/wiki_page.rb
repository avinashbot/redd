# frozen_string_literal: true

require_relative 'lazy_model'

module Redd
  module Models
    # A reddit user.
    class WikiPage < LazyModel
      # Make a Wikipage from its title and subreddit.
      # @option hash [String] :title the page's title
      # @option hash [Subreddit] :subreddit the page's subreddit
      # @return [WikiPage]
      def self.from_response(client, hash)
        title = hash.fetch(:title)
        if hash.key?(:subreddit)
          sr_name = hash[:subreddit].display_name
          new(client, hash) { |c| c.get("/r/#{sr_name}/wiki/#{title}").body[:data] }
        else
          new(client, hash) { |c| c.get("/wiki/#{title}").body[:data] }
        end
      end
    end
  end
end
