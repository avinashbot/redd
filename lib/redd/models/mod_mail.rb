# frozen_string_literal: true

require_relative 'basic_model'
require_relative 'subreddit'

module Redd
  module Models
    # A container for the new modmail.
    # XXX: Instead of making ModMail a dumb container, could it be a lazy wrapper for #unread_count?
    class ModMail < BasicModel
      # Represents a conversation in the new modmail.
      # TODO: add modmail-specific user type
      class Conversation < LazyModel
        # Get a Conversation from its id.
        # @option hash [String] :id the base36 id (e.g. abc123)
        # @return [Conversation]
        def self.from_response(client, hash)
          id = hash.fetch(:id)
          new(client, hash) do |c|
            response = c.get("/api/mod/conversations/#{id}").body
            response[:conversation].merge(
              messages: response[:messages].values.map { |m| Message.from_response(c, m) },
              user: response[:user],
              mod_actions: response[:modActions]
            )
          end
        end

        # Get a Conversation from its id.
        # @param id [String] the base36 id (e.g. abc123)
        # @return [Conversation]
        def self.from_id(client, id)
          from_response(client, id: id)
        end

        # Add a reply to the ongoing conversation.
        def reply(body, hidden: false, internal: false)
          # TODO: merge response into the conversation
          @client.post(
            "/api/mod/conversations/#{get_attribute(:id)}",
            body: body, isAuthorHidden: hidden, isInternal: internal
          ).body
        end

        # Mark this conversation as read.
        def mark_as_read
          @client.post('/api/mod/conversations/read', conversationIds: [get_attribute(:id)])
        end

        # Mark this conversation as unread.
        def mark_as_unread
          @client.post('/api/mod/conversations/unread', conversationIds: [get_attribute(:id)])
        end

        # Mark this conversation as archived.
        def archive
          perform_action(:post, 'archive')
        end

        # Removed this conversation from archived.
        def unarchive
          perform_action(:post, 'unarchive')
        end

        # Highlight this conversation.
        def highlight
          perform_action(:post, 'highlight')
        end

        # Remove the highlight on this conversation.
        def unhighlight
          perform_action(:delete, 'highlight')
        end

        # Mute this conversation.
        def mute
          perform_action(:post, 'mute')
        end

        # Unmute this conversation.
        def unmute
          perform_action(:post, 'unmute')
        end

        private

        # Perform an action on a conversation.
        # @param method [:post, :delete] the method to use
        # @param action [String] the name of the action
        def perform_action(method, action)
          @client.send(method, "/api/mod/conversations/#{id}/#{action}")
        end
      end

      # A conversation message.
      class Message < BasicModel; end

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
        @client.get('/api/mod/conversations', **params).body[:conversations].map do |_, conv|
          Conversation.from_response(@client, conv)
        end
      end

      # Create a new conversation.
      # @param from [Subreddit] the subreddit to send the conversation from
      # @param to [User] the person to send the message to
      # @param subject [String] the message subject
      # @param body [String] the message body
      # @return [Conversation] the created conversation
      def create(from:, to:, subject:, body:, hidden: false)
        Conversation.from_response(@client, @client.post(
          '/api/mod/conversations',
          srName: from.display_name, to: to.name,
          subject: subject, body: body, isAuthorHidden: hidden
        ).body[:conversation])
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
