# frozen_string_literal: true

require_relative 'lazy_model'

module Redd
  module Models
    # A multi.
    class Multireddit < LazyModel
      # Create a Multireddit from its path.
      # @param client [APIClient] the api client to initialize the object with
      # @param id [String] the multi's path (with a leading and trailing slash)
      # @return [Multireddit]
      def self.from_id(client, id)
        new(client, path: id)
      end

      # Get the appropriate listing.
      # @param sort [:hot, :new, :top, :controversial, :comments, :rising, :gilded] the type of
      #   listing
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
        @client.model(:get, "#{get_attribute(:path)}#{sort}", params)
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

      private

      def after_initialize
        @attributes[:subreddits].map! do |subreddit|
          Subreddit.new(client, display_name: subreddit[:name])
        end
      end

      def default_loader
        @client.get("/api/multi#{@attributes.fetch(:path)}").body[:data]
      end
    end
  end
end
