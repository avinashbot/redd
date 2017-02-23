# frozen_string_literal: true

require_relative 'basic_model'
require_relative '../utilities/stream'

module Redd
  module Models
    # The front page.
    # FIXME: deal with serious code duplication from Subreddit
    class FrontPage < BasicModel
      # @return [Array<String>] reddit's base wiki pages
      def wiki_pages
        @client.get('/wiki/pages').body[:data]
      end

      # Get a wiki page by its title.
      # @param title [String] the page's title
      # @return [WikiPage]
      def wiki_page(title)
        WikiPage.from_response(@client, title: title)
      end

      # Get the appropriate listing.
      # @param sort [:hot, :new, :top, :controversial, :comments, :rising] the type of listing
      # @param params [Hash] a list of params to send with the request
      # @option params [String] :after return results after the given fullname
      # @option params [String] :before return results before the given fullname
      # @option params [Integer] :count the number of items already seen in the listing
      # @option params [1..100] :limit the maximum number of things to return
      # @option params [:hour, :day, :week, :month, :year, :all] :time the time period to consider
      #   when sorting.
      #
      # @note The option :time only applies to the top and controversial sorts.
      # @return [Listing<Submission>]
      def listing(sort, **params)
        params[:t] = params.delete(:time) if params.key?(:time)
        @client.model(:get, "/#{sort}.json", params)
      end

      # @!method hot(**params)
      # @!method new(**params)
      # @!method top(**params)
      # @!method controversial(**params)
      # @!method comments(**params)
      # @!method rising(**params)
      #
      # @see #listing
      %i(hot new top controversial comments rising).each do |sort|
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
