# frozen_string_literal: true

require_relative 'basic_model'

module Redd
  module Models
    # A backward-expading listing of items.
    # @see Stream
    class Listing < BasicModel
      include Enumerable

      # @return [Array<Comment, Submission, PrivateMessage>] an array representation of self
      def to_ary
        get_attribute(:children)
      end

      %i([] each empty? first last).each do |method_name|
        define_method(method_name) do |*args, &block|
          get_attribute(:children).public_send(method_name, *args, &block)
        end
      end
    end
  end
end
