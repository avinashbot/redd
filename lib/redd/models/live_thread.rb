# frozen_string_literal: true

require_relative 'model'

module Redd
  module Models
    # Represents a live thread.
    class LiveThread < Model
      # Get the updates from the thread.
      # @param params [Hash] a list of params to send with the request
      # @option params [String] :after return results after the given fullname
      # @option params [String] :before return results before the given fullname
      # @option params [Integer] :count the number of items already seen in the listing
      # @option params [1..100] :limit the maximum number of things to return
      # @return [Listing]
      def updates(**params)
        client.model(:get, "/live/#{read_attribute(:id)}", params)
      end

      # Configure the settings of this live thread
      # @param params [Hash] a list of params to send with the request
      # @option params [String] :description the new description
      # @option params [Boolean] :nsfw whether the thread is for users 18 and above
      # @option params [String] :resources the new resources
      # @option params [String] :title the thread title
      def configure(**params)
        client.post("/api/live/#{read_attribute(:id)}/edit", params)
      end

      # Add an update to this live event.
      # @param body [String] the update text
      def update(body)
        client.post("/api/live/#{read_attribute(:id)}/update", body: body)
      end

      # Strike out a live thread update.
      # @param live_update [LiveUpdate] the update to strike out
      def strike_update(live_update)
        client.post("/api/live/#{read_attribute(:id)}/strike_update", id: live_update.name)
      end

      # Delete a live thread update.
      # @param live_update [LiveUpdate] the update to strike out
      def delete_update(live_update)
        client.post("/api/live/#{read_attribute(:id)}/delete_update", id: live_update.name)
      end

      # @return [Array<User>] the contributors to this thread
      def contributors
        client.get("/live/#{read_attribute(:id)}/contributors").body[0][:data].map do |user|
          User.new(client, user)
        end
      end

      # @return [Array<User>] users invited to contribute to this thread
      def invited_contributors
        client.get("/live/#{read_attribute(:id)}/contributors").body[1][:data].map do |user|
          User.new(client, user)
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
        client.model(:get, "/live/#{read_attribute(:id)}/discussions", params)
      end

      # @!attribute [r] id
      #   @return [String] the thread id
      property :id, :required

      # @!attribute [r] name
      #   @return [String] the thread fullname
      property :name, default: ->() { "LiveUpdateEvent_#{read_attribute(:id)}" }

      # @!attribute [r] description
      #   @return [String] the live thread description
      property :description

      # @!attribute [r] description_html
      #   @return [String] the html-rendered thread description
      property :description_html

      # @!attribute [r] title
      #   @return [String] the live thread title
      property :title

      # @!attribute [r] created_at
      #   @return [String] the live thread creation time
      property :created_at, from: :created_utc, with: ->(t) { Time.at(t) }

      # @!attribute [r] websocket_url
      #   @return [String] the websocket url for listening to updates
      property :websocket_url

      # @!attribute [r] state
      #   @return [String] the thread state (e.g. "live")
      property :state

      # @!attribute [r] nsfw?
      #   @return [Boolean] whether the thread is nsfw
      property :nsfw?, from: :nsfw

      # @!attribute [r] viewer_count
      #   @return [Integer] the thread viewer count
      property :viewer_count

      # @!attribute [r] viewer_count_fuzzed?
      #   @return [Boolean] whether the viewer count is fuzzed
      property :viewer_count_fuzzed?, from: :viewer_count_fuzzed

      # @!attribute [r] resources
      #   @return [String] the thread's resources section
      property :resources

      # @!attribute [r] resources_html
      #   @return [String] the html-rendered thread resources
      property :resources_html

      private

      def lazer_reload
        client.get("/live/#{read_attribute(:id)}/about").body[:data]
      end
    end
  end
end
