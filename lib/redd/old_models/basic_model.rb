# frozen_string_literal: true

module Redd
  module Models
    # The base class for all models.
    class BasicModel
      # @abstract Create an instance from a value.
      # @param _client [APIClient] the api client to initialize the object with
      # @param _value [Object] the object to coerce
      # @return [BasicModel]
      def self.from_id(_client, _value)
        # TODO: abstract this out?
        raise "coercion not implemented for #{name}"
      end

      # @return [APIClient] the client the model was initialized with
      attr_reader :client

      # Create a non-lazily initialized class.
      # @param client [APIClient] the client that the model uses to make requests
      # @param attributes [Hash] the class's attributes
      def initialize(client, attributes = {})
        @client = client
        @attributes = attributes
        after_initialize
      end

      # @return [Hash] a Hash representation of the object
      def to_h
        @attributes
      end

      # @return [Array<self>] an array representation of self
      def to_ary
        [self]
      end

      # @return [String] an easily readable representation of the object
      def inspect
        "#{super}\n" + @attributes.map { |a, v| "  #{a}: #{v}" }.join("\n")
      end

      # Checks whether an attribute is supported by method_missing.
      # @param method_name [Symbol] the method name or attribute to check
      # @param include_private [Boolean] whether to also include private methods
      # @return [Boolean] whether the method is handled by method_missing
      def respond_to_missing?(method_name, include_private = false)
        @attributes.key?(method_name) || @attributes.key?(depredicate(method_name)) || super
      end

      # Return an attribute or raise a NoMethodError if it doesn't exist.
      # @param method_name [Symbol] the name of the attribute
      # @return [Object] the result of the attribute check
      def method_missing(method_name, *args, &block)
        return get_attribute(method_name) if @attributes.key?(method_name)
        return get_attribute(depredicate(method_name)) if @attributes.key?(depredicate(method_name))
        super
      end

      private

      # @abstract Lets us plug in custom code without making a mess
      def after_initialize; end

      # Remove a trailing '?' from a symbol name.
      # @param method_name [Symbol] the symbol to "depredicate"
      # @return [Symbol] the symbol but with the '?' removed
      def depredicate(method_name)
        method_name.to_s.chomp('?').to_sym
      end

      # Get an attribute, raising KeyError if not present.
      # @param name [Symbol] the attribute to check and get
      # @return [Object] the value of the attribute
      def get_attribute(name)
        @attributes.fetch(name)
      end
    end
  end
end
