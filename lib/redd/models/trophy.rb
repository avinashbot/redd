# frozen_string_literal: true

require_relative 'model'

module Redd
  module Models
    # A user trophy.
    class Trophy < Model
      # @!attribute [r] icon_70px
      #   @return [String] the url for a 70x70 thumbnail icon
      property :icon_70px, from: :icon_70

      # @!attribute [r] icon_40px
      #   @return [String] the url for a 40x40 thumbnail icon
      property :icon_40px, from: :icon_40

      # @!attribute [r] name
      #   @return [String] the name of the trophy
      property :name

      # @!attribute [r] id
      #   @return [String] the trophy id
      property :id

      # @!attribute [r] award_id
      #   @return [String]
      property :award_id

      # @!attribute [r] description
      #   @return [String] the trophy description
      property :description
    end
  end
end
