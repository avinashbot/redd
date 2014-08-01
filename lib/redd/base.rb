require "memoizable"

module Redd
  # A container for various models with attributes and a client.
  class Base
    include Memoizable

    # @!attribute [r] attributes
    # @return [Hash] A list of attributes returned by reddit for this object.
    attr_reader :attributes
    alias_method :to_h, :attributes

    # @!attribute [r] client
    # @return The client instance used to make requests with this object.
    attr_reader :client

    # Define and memoize the method that returns a key from the
    # attributes hash.
    # @param [Symbol, String] attr The attribute to construct a method out of.
    def self.attr_reader(attr)
      define_attribute_method(attr)
      define_predicate_method(attr)
    end

    def [](method)
      send(method.to_sym)
    rescue NoMethodError
      nil
    end


    # @param client The client to use when making requests with this object.
    #   This is similar to reddit_session in praw.
    # @param [Hash] attributes
    def initialize(client, attributes)
      @client = client
      @attributes = attributes[:data]
      @attributes[:kind] = attributes[:kind]
    end

    private

    def define_attribute_method(method)
      define_method(method) { @attributes[method] }
      memoize method
    end

    def define_predicate_method(method)
      define_method(:"#{method}?") { !!@attributes[method] }
      memoize :"#{method}?"
    end
  end
end
