# frozen_string_literal: true

require_relative 'model'

module Redd
  module Models
    # A backward-expading listing of items.
    # @see Stream
    class Listing < Model
      include Enumerable

      # Create a fully initialized listing.
      # @param client [APIClient] the api client
      # @param attributes [Hash] the attribute hash
      def initialize(client, attributes = {})
        super
        fully_loaded!
      end

      # @return [Array<Comment, Submission, PrivateMessage>] an array representation of self
      def to_a
        read_attribute(:children)
      end
      alias to_ary to_a

      %i[[] each empty? first last].each do |method_name|
        define_method(method_name) do |*args, &block|
          read_attribute(:children).public_send(method_name, *args, &block)
        end
      end

      # @!attribute [r] before
      #   @return [String] the fullname of the item before this listing
      property :before, :nil

      # @!attribute [r] after
      #   @return [String] the fullname of the item that the next listing will start from
      property :after, :nil

      # @!attribute [r] children
      #   @return [Array<Model>] the listing's children
      property :children, :required, with: ->(a) { a.map { |m| client.unmarshal(m) } }
    end
  end
end
