# frozen_string_literal: true

require 'lazy_lazer'

module Redd
  module Models
    # A base model class.
    class Model
      include LazyLazer

      # @return [Client] the model's client
      attr_reader :client

      # Create a new Model.
      # @param client [Client] the model's client
      # @param attributes [Hash] the model's attributes
      def initialize(client, attributes = {})
        super(attributes)
        @client = client
      end
    end
  end
end
