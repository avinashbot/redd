# frozen_string_literal: true

require_relative 'basic_model'

module Redd
  module Models
    # An object that represents a bunch of comments that need to be expanded.
    class MoreComments < BasicModel
      # Expand the object's children into a listing of Comments and MoreComments.
      # @param link [Submission] the submission the object belongs to
      # @param sort [String] the sort order of the submission
      # @return [Listing<Comment, MoreComments>] the expanded children
      def expand(link:, sort: 'best')
        @client.model(
          :get, '/api/morechildren',
          link_id: link.name,
          children: get_attribute(:children).join(','),
          sort: sort
        )
      end

      # Keep expanding until all top-level MoreComments are converted to comments.
      # @param link [Submission] the object's submission
      # @param sort [String] the sort order of the returned comments
      # @param lookup [Hash] a hash of comments to add future replies to
      # @param depth [Number] the maximum recursion depth
      # @return [Array<Comment, MoreComments>] the expanded comments or {self} if past depth
      def recursive_expand(link:, sort: 'best', lookup: {}, depth: 10)
        return [self] if depth == 0

        expand(link: link, sort: sort).flat_map do |thing|
          if thing.is_a?(MoreComments) && thing.count > 0
            # Get an array of expanded comments from the thing.
            ary = thing.recursive_expand(link: link, sort: sort, lookup: lookup, depth: depth - 1)
            # If we can't find its parent (or if the parent is the submission), add it to the root.
            next ary unless lookup.key?(thing.parent_id)
            # Since the thing has a parent that we're tracking, attach it to the parent.
            lookup[thing.parent_id].replies.children.concat(ary)
          elsif thing.is_a?(Comment)
            # Add the comment to a lookup hash.
            lookup[thing.name] = thing
            # If the parent is not in the lookup hash, add it to the root listing.
            next thing unless lookup.key?(thing.parent_id)
            # If the parent was found, add the child to the parent's replies instead.
            lookup[thing.parent_id].replies.children << thing
          end
          []
        end
      end

      # @return [Array<String>] an array representation of self
      def to_ary
        get_attribute(:children)
      end
    end
  end
end
