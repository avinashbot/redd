# frozen_string_literal: true

require_relative 'model'
require_relative 'subreddit'

module Redd
  module Models
    # A container for the new modmail.
    class Modmail < Model
      # @return [Hash<Symbol, Integer>] the number of unread messages in each category
      def unread_count
        client.get('/api/mod/conversations/unread/count').body
      end

      # @return [Array<Subreddit>] moderated subreddits that are enrolled in the new modmail
      def enrolled
        client.get('/api/mod/conversations/subreddits').body[:subreddits].map do |_, s|
          Subreddit.new(client, s.merge(last_updated: s.delete(:lastUpdated)))
        end
      end

      # Get the conversations
      # @param subreddits [Subreddit, Array<Subreddit>] the subreddits to limit to
      # @param params [Hash] additional request parameters
      # @option params [String] :after base36 modmail conversation id
      # @option params [Integer] :limit an integer (default: 25)
      # @option params [:recent, :mod, :user, :unread] :sort the sort order
      # @option params [:new, :inprogress, :mod, :notifications, :archived, :highlighted, :all]
      #   :state the state to limit the conversations by
      # @return [Array<ModmailConversation>] the conversations
      def conversations(subreddits: nil, **params)
        params[:entity] = Array(subreddits).map(&:display_name).join(',') if subreddits
        client.get('/api/mod/conversations', **params)
              .body[:conversations]
              .values
              .map { |conv| ModmailConversation.new(client, conv) }
      end

      # Create a new conversation.
      # @param from [Subreddit] the subreddit to send the conversation from
      # @param to [User] the person to send the message to
      # @param subject [String] the message subject
      # @param body [String] the message body
      # @return [ModmailConversation] the created conversation
      def create(from:, to:, subject:, body:, hidden: false)
        ModmailConversation.new(client, client.post(
          '/api/mod/conversations',
          srName: from.display_name, to: to.name,
          subject: subject, body: body, isAuthorHidden: hidden
        ).body[:conversation])
      end

      # Get a conversation from its base36 id.
      # @param id [String] the conversation's id
      # @return [ModmailConversation]
      def get(id)
        ModmailConversation.new(client, id: id)
      end
    end
  end
end
