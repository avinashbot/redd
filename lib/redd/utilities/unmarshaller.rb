# frozen_string_literal: true

module Redd
  module Utilities
    # Unmarshals hashes into objects.
    class Unmarshaller
      # Contains the mapping from 'kind' strings to classes.
      MAPPING = {
        't1'           => Models::Comment,
        't2'           => Models::User,
        't3'           => Models::Submission,
        't4'           => Models::PrivateMessage,
        't5'           => Models::Subreddit,
        'more'         => Models::MoreComments,
        'wikipage'     => Models::WikiPage,
        'Listing'      => Models::Listing,
        'LabeledMulti' => Models::Multireddit
      }.freeze

      def initialize(client)
        @client = client
      end

      def unmarshal(response)
        if response[:json] && response[:json][:data]
          if response[:json][:data][:things]
            Models::Listing.from_response(@client, children: response[:json][:data][:things])
          else
            Models::BasicModel.new(@client, response[:json][:data])
          end
        elsif MAPPING.key?(response[:kind])
          MAPPING[response[:kind]].from_response(@client, response[:data])
        else
          raise "unknown type to unmarshal: #{response[:kind].inspect}"
        end
      end
    end
  end
end
