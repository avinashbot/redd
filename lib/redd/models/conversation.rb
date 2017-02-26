# frozen_string_literal: true

require_relative 'lazy_model'

module Redd
  module Models
    # Represents a conversation in the new modmail.
    # TODO: add message and modmail-specific user type
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
  end
end
