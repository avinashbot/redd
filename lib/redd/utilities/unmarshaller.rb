# frozen_string_literal: true

module Redd
  module Utilities
    # Unmarshals hashes into objects.
    class Unmarshaller
      # Contains the mapping from 'kind' strings to classes.
      # TODO: UserList type!
      MAPPING = {
        'Listing'      => Models::Listing,
        't1'           => Models::Comment,
        't2'           => Models::User,
        't3'           => Models::Submission,
        't4'           => Models::PrivateMessage,
        't5'           => Models::Subreddit,
        't6'           => Models::Trophy,
        'more'         => Models::MoreComments,
        'wikipage'     => Models::WikiPage,
        'modaction'    => Models::ModAction,
        'LabeledMulti' => Models::Multireddit,
        'LiveUpdate'   => Models::LiveUpdate
      }

      def initialize(client)
        @client = client
      end

      def unmarshal(res)
        # I'm loving the hell out of this pattern.
        model = js_listing(res) || js_model(res) || api_model(res)
        raise "cannot unmarshal: #{res.inspect}" if model.nil?
        model
      end

      private

      # Unmarshal frontent API-style listings
      def js_listing(res)
        # One day I'll get to deprecate Ruby 2.2 and jump into the world of Hash#dig.
        return nil unless res[:json] && res[:json][:data] && res[:json][:data][:things]
        Models::Listing.new(@client, children: res[:json][:data][:things])
      end

      # Unmarshal frontend API-style models.
      def js_model(res)
        # FIXME: deprecate this? this shouldn't be happening in the API, so this is better handled
        #   in the respective classes.
        Models::Model.new(@client, res[:json][:data]) if res[:json] && res[:json][:data]
      end

      # Unmarshal API-provided listings.
      def api_listing(res)
        return nil unless res[:kind] == 'Listing'
        attributes = res[:data]
        attributes[:children].map! { |child| unmarshal(child) }
        Models::Listing.new(@client, attributes)
      end

      # Unmarshal API-provided model.
      def api_model(res)
        return nil unless MAPPING[res[:kind]]
        MAPPING[res[:kind]].new(@client, res[:data])
      end
    end
  end
end
