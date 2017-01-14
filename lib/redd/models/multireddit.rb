# frozen_string_literal: true

require_relative 'lazy_model'

module Redd
  module Models
    # A multi.
    class Multireddit < LazyModel
      # Make a Multireddit from its path.
      # @option hash [String] :path the multi's path
      # @return [Multireddit]
      def self.from_response(client, hash)
        path = hash.fetch(:path)
        new(client, hash) { |c| c.get("/api/multi#{path}").body[:data] }
      end

      # Create a Multireddit from its path.
      # @param client [APIClient] the api client to initialize the object with
      # @param id [String] the multi's path (prepended by a /)
      # @return [Multireddit]
      def self.from_id(client, id)
        from_response(client, path: id)
      end

      def after_initialize
        @attributes[:subreddits].map! do |subreddit|
          Subreddit.from_response(client, display_name: subreddit[:name])
        end
      end
    end
  end
end
