# frozen_string_literal: true

require 'time'
require_relative 'model'

module Redd
  module Models
    # Represents a conversation in the new modmail.
    class ModmailConversation < Model
      # Add a reply to the ongoing conversation.
      # @param body [String] the message body (probably markdown)
      # @param hidden [Boolean] whether the message is hidden
      # @param internal [Boolean] whether the message is internal
      def reply(body, hidden: false, internal: false)
        # TODO: merge response into the conversation
        client.post(
          "/api/mod/conversations/#{read_attribute(:id)}",
          body: body, isAuthorHidden: hidden, isInternal: internal
        ).body
      end

      # Mark this conversation as read.
      def mark_as_read
        client.post('/api/mod/conversations/read', conversationIds: [read_attribute(:id)])
      end

      # Mark this conversation as unread.
      def mark_as_unread
        client.post('/api/mod/conversations/unread', conversationIds: [read_attribute(:id)])
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

      # @!attribute [r] id
      #   @return [String] the conversation id
      property :id, :required

      # @!attribute [r] messages
      #   @return [Array<ModmailMessage>] the modmail messages
      property :messages, with: ->(hsh) { hsh.values.map { |m| ModmailMessage.new(client, m) } }

      # @!attribute [r] user
      #   @return [Object] FIXME: details about the user the conversation deals with
      property :user

      # @!attribute [r] auto?
      #   @return [Boolean]
      property :auto?, from: :isAuto

      # @!attribute [r] message_ids
      #   @return [Array<String>] the conversation's message ids
      property :message_ids, from: :objIds

      # @!attribute [r] replyable?
      #   @return [Boolean] whether you can reply to this conversation
      property :replyable?, from: :isRepliable

      # @!attribute [r] last_user_update
      #   @return [Time] the time of last user update
      property :last_user_update, from: :lastUserUpdate, with: ->(t) { Time.parse(t) }

      # @!attribute [r] internal?
      #   @return [Boolean]
      property :internal?, from: :isInternal

      # @!attribute [r] last_mod_update
      #   @return [Time] the time of last mod update
      property :last_mod_update, from: :lastModUpdate, with: ->(t) { Time.parse(t) }

      # @!attribute [r] last_updated
      #   @return [Time] the time of last update
      property :last_updated, from: :lastUpdated, with: ->(t) { Time.parse(t) }

      # @!attribute [r] authors
      #   @return [Array<Hash>] FIXME: apply conversions
      property :authors

      # @!attribute [r] owner
      #   @return [Hash] FIXME: do shit
      property :owner

      # @!attribute [r] highlighted?
      #   @return [Boolean] whether the conversation is highlighted
      property :highlighted?, from: :isHighlighted

      # @!attribute [r] subject
      #   @return [String] the conversation subject
      property :subject

      # @!attribute [r] participant
      #   @return [Hash] FIXME: do shit
      property :participant

      # @!attribute [r] state
      #   @return [Integer]
      property :state

      # @!attribute [r] last_unread
      #   @return [Object]
      property :last_unread, from: :lastUnread

      # @!attribute [r] message_count
      #   @return [Integer] the message count
      property :message_count, from: :numMessages

      private

      def lazer_reload
        fully_loaded!
        response = client.get("/api/mod/conversations/#{read_attribute(:id)}").body
        response[:conversation].merge(
          messages: response[:messages],
          user: response[:user],
          modActions: response[:modActions]
        )
      end

      # Perform an action on a conversation.
      # @param method [:post, :delete] the method to use
      # @param action [String] the name of the action
      def perform_action(method, action)
        client.send(method, "/api/mod/conversations/#{read_attribute(:id)}/#{action}")
      end
    end
  end
end
