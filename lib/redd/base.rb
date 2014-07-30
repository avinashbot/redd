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
    # @param [Symbol, String] key The key to construct a method out of.
    # @param [Symbol] attribute The attribute in the given hash to return.
    def self.attr_reader(key, attribute = key)
      define_method(key) { @attributes[attribute] }
      memoize(key)
    end

    # @param client The client to use when making requests with this object.
    #   This is similar to reddit_session in praw.
    # @param [Hash] attributes
    def initialize(client, attributes)
      @client = client
      @attributes = attributes[:data]
      @attributes[:kind] = attributes[:kind]
    end
  end
end
