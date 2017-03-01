# frozen_string_literal: true

require_relative 'lazy_model'
require_relative 'gildable'
require_relative 'inboxable'
require_relative 'moderatable'
require_relative 'postable'
require_relative 'replyable'

require_relative 'listing'
require_relative 'subreddit'
require_relative 'user'

module Redd
  module Models
    # A comment.
    class Comment < LazyModel
      include Gildable
      include Inboxable
      include Moderatable
      include Postable
      include Replyable

      # Create a Comment from its fullname.
      # @param client [APIClient] the api client to initialize the object with
      # @param id [String] the fullname
      # @return [Comment]
      def self.from_id(client, id)
        new(client, name: id)
      end

      private

      def after_initialize
        @attributes[:replies] =
          if !@attributes.key?(:replies) || @attributes[:replies] == ''
            Listing.new(@client, children: [])
          else
            @client.unmarshal(@attributes[:replies])
          end
        @attributes[:author] = User.from_id(@client, @attributes.fetch(:author))
        @attributes[:subreddit] = Subreddit.from_id(@client, @attributes.fetch(:subreddit))
      end

      def default_loader
        # Ensure we have the comment's id.
        id = @attributes.fetch(:id) { @attributes.fetch(:name).sub('t1_', '') }

        # If we have the link_id, we can load the listing with replies.
        if @attributes.key?(:link_id)
          link_id = @attributes[:link_id].sub('t3_', '')
          return @client.get("/comments/#{link_id}/_/#{id}").body[1][:data][:children][0][:data]
        end
        # We can only load the comment in isolation if we don't have the link_id.
        @client.get('/api/info', id: "t1_#{id}").body[:data][:children][0][:data]
      end
    end
  end
end
