# frozen_string_literal: true

require_relative 'basic_model'

module Redd
  module Models
    # An object that represents a bunch of comments that need to be expanded.
    class MoreComments < BasicModel
      # Expand the object's children into a listing of Comments and MoreComments.
      # @param link [String] the fullname of the submission the object belongs to
      # @param sort [String] the sort order of the submission
      # @return [Listing<Comment, MoreComments>] the expanded children
      def expand(link:, sort: 'best')
        @client.model(
          :get, '/api/morechildren',
          link_id: link,
          children: get_attribute(:children).join(','),
          sort: sort
        )
      end

      # @return [Array<String>] an array representation of self
      def to_ary
        get_attribute(:children)
      end

      # Keep expanding until all top-level MoreComments are converted to comments
      def recursive_expand(link:, sort: 'best')
        # FIXME: this returns a flattened listing of comments and doesn't preserve the structure
        expand(link: link, sort: sort).flat_map do |o|
          o.is_a?(MoreComments) && o.count > 0 ? o.recursive_expand(link: link, sort: sort) : [o]
        end
      end
    end
  end
end
