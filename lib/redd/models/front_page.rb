# frozen_string_literal: true

require_relative 'model'
require_relative '../utilities/stream'

module Redd
  module Models
    # The front page.
    # FIXME: deal with serious code duplication from Subreddit
    class FrontPage < Model
      # @return [Array<String>] reddit's base wiki pages
      def wiki_pages
        client.get('/wiki/pages').body[:data]
      end

      # Get a wiki page by its title.
      # @param title [String] the page's title
      # @return [WikiPage]
      def wiki_page(title)
        WikiPage.new(client, title: title)
      end

      # Get the appropriate listing.
      # @param sort [:hot, :new, :top, :controversial, :comments, :rising, :gilded] the type of
      #   listing
      # @param options [Hash] a list of options to send with the request
      # @option options [String] :after return results after the given fullname
      # @option options [String] :before return results before the given fullname
      # @option options [Integer, nil] :limit maximum number of items to return (nil for no limit)
      # @option options [:hour, :day, :week, :month, :year, :all] :time the time period to consider
      #   when sorting.
      #
      # @note The option :time only applies to the top and controversial sorts.
      # @return [PaginatedListing<Submission>]
      def listing(sort, **options)
        options[:t] = options.delete(:time) if options.key?(:time)
        PaginatedListing.new(client, options) do |**req_options|
          client.model(:get, "/#{sort}", options.merge(req_options))
        end
      end

      # @!method hot(**params)
      # @!method new(**params)
      # @!method top(**params)
      # @!method controversial(**params)
      # @!method comments(**params)
      # @!method rising(**params)
      # @!method gilded(**params)
      #
      # @see #listing
      %i[hot new top controversial comments rising gilded].each do |sort|
        define_method(sort) { |**params| listing(sort, **params) }
      end

      # Stream newly submitted posts.
      def post_stream(**params, &block)
        params[:limit] ||= 100
        stream = Utilities::Stream.new do |before|
          listing(:new, params.merge(before: before))
        end
        block_given? ? stream.stream(&block) : stream.enum_for(:stream)
      end

      # Stream newly submitted comments.
      def comment_stream(**params, &block)
        params[:limit] ||= 100
        stream = Utilities::Stream.new do |before|
          listing(:comments, params.merge(before: before))
        end
        block_given? ? stream.stream(&block) : stream.enum_for(:stream)
      end
    end
  end
end
