# frozen_string_literal: true

require_relative 'model'
require_relative 'inboxable'
require_relative 'replyable'
require_relative 'reportable'

module Redd
  module Models
    # A private message
    class PrivateMessage < Model
      include Inboxable
      include Replyable
      include Reportable

      # Delete the message from the user's inbox.
      def delete
        client.post('/api/del_msg', id: read_attribute(:name))
      end

      # Mute the author of the message.
      def mute_author
        client.post('/api/mute_message_author', id: read_attribute(:name))
      end

      # Unmute the author of the message.
      def unmute_author
        client.post('/api/unmute_message_author', id: read_attribute(:name))
      end

      # @!attribute [r] first_message
      #   @return [Integer] not sure what this does
      property :first_message

      # @!attribute [r] first_message_name
      #   @return [String] the fullname of the first message
      property :first_message_name

      # @!attribute [r] subreddit
      #   @return [Subreddit, nil] the subreddit that sent the message
      property :subreddit, with: ->(s) { Subreddit.new(client, display_name: s) if s }

      # @!attribute [r] replies
      #   @return [Listing<PrivateMessage>]
      property :replies, with: ->(l) { Listing.new(client, l[:data]) if l.is_a?(Hash) }

      # @!attribute [r] id
      #   @return [String] the message id
      property :id

      # @!attribute [r] subject
      #   @return [String] the message subject
      property :subject

      # @!attribute [r] was_comment?
      #   @return [Boolean]
      property :was_comment?, from: :was_comment

      # @!attribute [r] author
      #   @return [User] the message author
      property :author, with: ->(n) { User.new(client, name: n) if n }

      # @!attribute [r] num_comments
      #   @return [Integer] huh?
      property :num_comments

      # @!attribute [r] parent_id
      #   @return [String, nil] the parent id
      property :parent_id

      # @!attribute [r] subreddit_name_prefixed
      #   @return [String] the subreddit name, prefixed with "r/"
      property :subreddit_name_prefixed

      # @!attribute [r] new?
      #   @return [Boolean] whether the message is new
      property :new?, from: :new

      # @!attribute [r] body
      #   @return [String] the message body
      property :body

      # @!attribute [r] body_html
      #   @return [String] the html-rendered version of the body
      property :body_html

      # @!attribute [r] dest
      #   @return [String] the recipient of the message
      #   @todo maybe convert the object to Subreddit/User?
      property :dest

      # @!attribute [r] name
      #   @return [String] the message fullname
      property :name

      # @!attribute [r] created
      #   @return [Time] the time the message was created
      property :created_utc, with: ->(t) { Time.at(t) }

      # @!attribute [r] distinguished
      #   @return [String] the level the message is distinguished
      property :distinguished
    end
  end
end
