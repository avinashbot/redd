require "hashie"
require "forwardable"

module Redd
  # A bunch of objects that can hold properties.
  module Objects
    # A base for all objects to inherit from.
    class Base < Hashie::Hash
      include Hashie::Extensions::MergeInitializer
      include Hashie::Extensions::MethodReader
      include Hashie::Extensions::MethodQuery
      include Hashie::Extensions::DeepMerge

      extend Forwardable
      def_delegators :@client, :get, :post, :put, :delete

      # @!attribute [r] client
      # @return [Clients::Base] The client that used to make requests.
      attr_reader :client

      # @param [Clients::Base] client The client instance.
      # @param [Hash] attributes A hash of attributes.
      def initialize(client, attributes = {})
        @client = client
        super(attributes)
      end

      # Define an alias for a property.
      # @param [Symbol] new_name The alias.
      # @param [Symbol] old_name The existing property.
      def self.alias_property(new_name, old_name)
        define_method(new_name) { send(old_name) }
      end
    end
  end
end
