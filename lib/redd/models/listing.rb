# frozen_string_literal: true

require_relative 'basic_model'

module Redd
  module Models
    # A backward-expading listing of items.
    # @see Stream
    class Listing < BasicModel
      include Enumerable

      # Make a Listing from a basic Hash.
      # @return [Listing]
      def self.from_response(client, hash)
        hash[:children].map! { |el| client.unmarshal(el) }
        new(client, hash)
      end

      %i([] each empty? length size).each do |method_name|
        define_method(method_name) do |*args, &block|
          get_attribute(:children).public_send(method_name, *args, &block)
        end
      end
    end
  end
end
