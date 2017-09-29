# frozen_string_literal: true

require 'lazy_lazer'

module Redd
  module Models
    # The base class for all models.
    class BaseModel
      include LazyLazer

      # @return [APIClient] the client the model was initialized with
      attr_reader :client

      # Create a lazily initialized class.
      # @param client [APIClient] the client that the model uses to make requests
      # @param attributes [Hash] the class's attributes
      def initialize(client, attributes = {})
        @client = client
        super(attributes)
      end
    end
  end
end
