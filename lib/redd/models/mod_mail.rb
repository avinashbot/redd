# frozen_string_literal: true

require_relative 'basic_model'
require_relative 'subreddit'
require_relative 'conversation'

module Redd
  module Models
    # A container for the new modmail.
    # XXX: Instead of making ModMail a dumb container, could it be a lazy wrapper for #unread_count?
    class ModMail < BasicModel
      # @return [#highlighted, #notifications, #archived, #new, #inprogress, #mod] the number of
      #   unread messages in each category
      def unread_count
        BasicModel.new(nil, @client.get('/api/mod/conversations/unread/count').body)
      end

      # @return [Array<Subreddit>] moderated subreddits that are enrolled in the new modmail
      def enrolled
        @client.get('/api/mod/conversations/subreddits').body[:subreddits].map do |_, s|
          Subreddit.from_response(@client, s.merge(last_updated: s.delete(:lastUpdated)))
        end
      end

      # Get the conversations
      # @param after [String] base36 modmail conversation id
      # @param subreddits [Subreddit, Array<Subreddit>] the subreddits to limit to
      # @param limit [Integer] an integer (default: 25)
      # @param sort [:recent, :mod, :user, :unread] the sort order
      # @param state [:new, :inprogress, :mod, :notifications, :archived, :highlighted, :all] the
      #   state to limit the conversations by
      def conversations(subreddits: nil, **params)
        params[:entity] = Array(subreddits).map(&:display_name).join(',') if subreddits
        @client.get('/api/mod/conversations', **params).body
      end

      # Get a conversation from its base36 id.
      # @param id [String] the conversation's id
      # @return [Conversation]
      def get(id)
        Conversation.from_id(@client, id)
      end
    end
  end
end
