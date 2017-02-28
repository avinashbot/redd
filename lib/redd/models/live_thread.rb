# frozen_string_literal: true

require_relative 'basic_model'
require_relative 'lazy_model'

module Redd
  module Models
    # Represents a live thread.
    class LiveThread < LazyModel
      # An update in a live thread.
      class LiveUpdate < BasicModel; end

      # Get a LiveThread from its id.
      # @param id [String] the id
      # @return [LiveThread]
      def self.from_id(client, id)
        new(client, id: id)
      end

      # Get the updates from the thread.
      # @param params [Hash] a list of params to send with the request
      # @option params [String] :after return results after the given fullname
      # @option params [String] :before return results before the given fullname
      # @option params [Integer] :count the number of items already seen in the listing
      # @option params [1..100] :limit the maximum number of things to return
      # @return [Listing]
      def updates(**params)
        @client.model(:get, "/live/#{get_attribute(:id)}", params)
      end

      # Configure the settings of this live thread
      # @param params [Hash] a list of params to send with the request
      # @option params [String] :description the new description
      # @option params [Boolean] :nsfw whether the thread is for users 18 and above
      # @option params [String] :resources the new resources
      # @option params [String] :title the thread title
      def configure(**params)
        @client.post("/api/live/#{get_attribute(:id)}/edit", params)
      end

      # Add an update to this live event.
      # @param body [String] the update text
      def update(body)
        @client.post("/api/live/#{get_attribute(:id)}/update", body: body)
      end

      # @return [Array<User>] the contributors to this thread
      def contributors
        @client.get("/live/#{get_attribute(:id)}/contributors").body[0][:data].map do |user|
          User.new(@client, user)
        end
      end

      # @return [Array<User>] users invited to contribute to this thread
      def invited_contributors
        @client.get("/live/#{get_attribute(:id)}/contributors").body[1][:data].map do |user|
          User.new(@client, user)
        end
      end

      # Returns all discussions that link to this live thread.
      # @param params [Hash] a list of params to send with the request
      # @option params [String] :after return results after the given fullname
      # @option params [String] :before return results before the given fullname
      # @option params [Integer] :count the number of items already seen in the listing
      # @option params [1..100] :limit the maximum number of things to return
      #
      # @return [Listing<Submission>]
      def discussions(**params)
        @client.model(:get, "/live/#{get_attribute(:id)}/discussions", params)
      end

      private

      def default_loader
        @client.get("/live/#{@attributes.fetch(:id)}/about").body[:data]
      end
    end
  end
end
