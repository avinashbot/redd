# frozen_string_literal: true

module Redd
  module Models
    # The base class for all models.
    class BasicModel
      class << self
        # @abstract Create an instance from a partial hash containing an id. The difference between
        # this and {#initialize} is that from_response is supposed to know how to build the whole
        # response from the partial.
        # @param client [APIClient] the api client to initialize the object with
        # @param hash [Hash] a partial hash
        # @return [BasicModel]
        def from_response(client, hash)
          new(client, hash)
        end

        # @abstract Create an instance from a value.
        # @param _client [APIClient] the api client to initialize the object with
        # @param _value [Object] the object to coerce
        # @return [BasicModel]
        def from_id(_client, _value)
          # TODO: abstract this out?
          raise "coercion not implemented for #{name}"
        end

        # @return [Hash<Symbol, #from_id>] a mapping of keys to models
        def coerced_attributes
          @coerced_attributes ||= {}
        end

        # Mark an attribute to coerce.
        # @param name [Symbol] the attribute to coerce
        # @param model [#from_id, nil] a model to coerce it to
        def coerce_attribute(name, model = nil)
          coerced_attributes[name] = model
        end
      end

      # @return [APIClient] the client the model was initialized with
      attr_reader :client

      # Create a non-lazily initialized class.
      # @param client [APIClient] the client that the model uses to make requests
      # @param attributes [Hash] the class's attributes
      def initialize(client, attributes = {})
        @client = client
        @attributes = attributes
        @to_coerce = self.class.coerced_attributes.keys
        after_initialize
      end

      # @return [Hash] a Hash representation of the object
      def to_h
        coerce_all_attributes
        @attributes
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

      # Coerces an attribute into a class using the {.from_id} method.
      # @param attribute [Symbol] the attribute to coerce
      def coerce_attribute(attribute)
        return unless @to_coerce.include?(attribute) && @attributes.include?(attribute)
        klass = self.class.coerced_attributes.fetch(attribute)
        @attributes[attribute] =
          if klass.nil?
            @client.unmarshal(@attributes[attribute])
          else
            klass.from_id(@client, @attributes[attribute])
          end
        @to_coerce.delete(attribute)
      end

      # Coerce every attribute that can be coerced.
      def coerce_all_attributes
        @to_coerce.each { |a| coerce_attribute(a) }
      end

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
        # Coerce the attribute if it exists and needs to be coerced.
        coerce_attribute(name) if @to_coerce.include?(name) && @attributes.key?(name)
        # Fetch the attribute, raising a KeyError if it doesn't exist.
        @attributes.fetch(name)
      end
    end
  end
end
