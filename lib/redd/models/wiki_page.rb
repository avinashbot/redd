# frozen_string_literal: true

require_relative 'lazy_model'

module Redd
  module Models
    # A reddit user.
    class WikiPage < LazyModel
      private

      def default_loader
        title = @attributes.fetch(:title)
        if @attributes.key?(:subreddit)
          sr_name = attributes[:subreddit].display_name
          return @client.get("/r/#{sr_name}/wiki/#{title}").body[:data]
        end
        @client.get("/wiki/#{title}").body[:data]
      end
    end
  end
end
