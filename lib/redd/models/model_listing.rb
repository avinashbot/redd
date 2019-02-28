# frozen_string_literal: true

require_relative 'model'

module Redd
  module Models
    # A backward-expading listing of model objects.
	  # Used in the case where the listing is built from Models.
    # @see Listing
    class ModelListing < Listing
      include Enumerable

      # @!attribute [r] children
      #   @return [Array<Models>] the listing's children, as model objects rather than hash objects
      property :children, :required, with: ->(a) { a.map { |m| client.unmarshal(m) } }
    end
  end
end
