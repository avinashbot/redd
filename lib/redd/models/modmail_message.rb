# frozen_string_literal: true

require 'time'
require_relative 'model'

module Redd
  module Models
    # Represents a message in the new modmail.
    class ModmailMessage < Model
      # @!attribute [r] id
      #   @return [String] the message id
      property :id

      # @!attribute [r] body
      #   @return [String] the html conversation body
      property :body

      # @!attribute [r] markdown_body
      #   @return [String] the body in markdown form
      property :markdown_body, from: :bodyMarkdown

      # @!attribute [r] author
      #   @return [Object] FIXME: do shit
      property :author

      # @!attribute [r] internal?
      #   @return [Boolean] whether the message is internal
      property :internal?, from: :isInternal

      # @!attribute [r] date
      #   @return [Time] the message date
      property :date, with: ->(t) { Time.parse(t) }
    end
  end
end
