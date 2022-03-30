# frozen_string_literal: true

require_relative 'model'

module Redd
  module Models
    # A live thread update.
    class LiveUpdate < Model
      # @!attribute [r] id
      #   @return [String] the update id
      property :id, :required

      # @!attribute [r] name
      #   @return [String] the update fullname
      property :name, default: -> { "LiveUpdate_#{read_attribute(:id)}" }

      # @!attribute [r] body
      #   @return [String] the update body
      property :body

      # @!attribute [r] body_html
      #   @return [String] the html-rendered update body
      property :body_html

      # @!attribute [r] embeds
      #   @return [Array]
      property :embeds

      # @!attribute [r] mobile_embeds
      #   @return [Array]
      property :mobile_embeds

      # @!attribute [r] author
      #   @return [User] the poster of the update
      property :author, with: ->(n) { User.new(client, name: n) }

      # @!attribute [r] created_at
      #   @return [Time] the post time
      property :created_at, from: :created_utc, with: ->(t) { Time.at(t) }

      # @!attribute [r] stricken?
      #   @return [Boolean] whether the update is stricken
      property :stricken?, from: :stricken
    end
  end
end
