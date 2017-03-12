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
      def expand(link:, sort: nil)
        params = { link_id: link.name, children: get_attribute(:children).join(',') }
        params[:sort] = sort if sort
        params[:sort] = link.sort_order if link.sort_order
        @client.model(:get, '/api/morechildren', params)
      end

      # Keep expanding until all top-level MoreComments are converted to comments.
      # @param link [Submission] the object's submission
      # @param sort [String] the sort order of the returned comments
      # @param lookup [Hash] a hash of comments to add future replies to
      # @param depth [Number] the maximum recursion depth
      # @return [Array<Comment, MoreComments>] the expanded comments or self if past depth
      def recursive_expand(link:, sort: nil, lookup: {}, depth: 10)
        return [self] if depth <= 0

        expand(link: link, sort: sort).each_with_object([]) do |thing, coll|
          target = (lookup.key?(thing.parent_id) ? lookup[thing.parent_id].replies.children : coll)

          if thing.is_a?(Comment)
            # Add the comment to a lookup hash.
            lookup[thing.name] = thing
            # If the parent is not in the lookup hash, add it to the root listing.
            target.push(thing)
          elsif thing.is_a?(MoreComments) && thing.count > 0
            # Get an array of expanded comments from the thing.
            ary = thing.recursive_expand(link: link, sort: sort, lookup: lookup, depth: depth - 1)
            target.concat(ary)
          end
        end
      end

      # @return [Array<String>] an array representation of self
      def to_ary
        get_attribute(:children)
      end
    end
  end
end
