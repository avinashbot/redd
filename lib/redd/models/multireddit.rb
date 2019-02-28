# frozen_string_literal: true

require_relative 'model'

module Redd
  module Models
    # A multi.
    class Multireddit < Model
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
      # @return [ModelListing<Submission>]
      def listing(sort, **params)
        params[:t] = params.delete(:time) if params.key?(:time)
        client.model(:get, "#{read_attribute(:path)}#{sort}", params)
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

      # @!attribute [r] can_edit?
      #   @return [Boolean] whether the user can edit the multireddit
      property :can_edit?, from: :can_edit

      # @!attribute [r] display_name
      #   @return [String] the multi's display name
      property :display_name

      # @!attribute [r] name
      #   @return [String] the multireddit name
      property :name

      # @!attribute [r] description_md
      #   @return [String] the markdown verion of the description
      property :description_md

      # @!attribute [r] description_html
      #   @return [String] the html-rendered description
      property :description_html

      # @!attribute [r] copied_from
      #   @return [Multireddit, nil] the multi this one was copied from
      property :copied_from, with: ->(n) { Multireddit.new(client, path: n) if n }

      # @!attribute [r] icon_url
      #   @return [String, nil] the icon url
      property :icon_url

      # @!attribute [r] subreddits
      #   @return [Array<Subreddit>] the subreddits in this multi
      property :subreddits,
               with: ->(a) { a.map { |n| Subreddit.new(client, display_name: n.fetch(:name)) } }

      # @!attribute [r] created_at
      #   @return [Time] the creation time
      property :created_at, from: :created_utc, with: ->(t) { Time.at(t) }

      # @!attribute [r] key_color
      #   @return [String] a hex color
      property :key_color

      # @!attribute [r] visibility
      #   @return [String] the multi visibility, either "public" or "private"
      property :visibility

      # @!attribute [r] icon_name
      #   @return [String] the icon name
      property :icon_name

      # @!attribute [r] weighting_scheme
      #   @return [String]
      property :weighting_scheme

      # @!attribute [r] path
      #   @return [String] the multi path
      property :path, :required

      private

      def lazer_reload
        client.get("/api/multi#{read_attribute(:path)}").body[:data]
      end
    end
  end
end
