# frozen_string_literal: true

module Redd
  module Utilities
    # Unmarshals hashes into objects.
    class Unmarshaller
      # Contains the mapping from 'kind' strings to classes.
      # TODO: UserList type!
      MAPPING = {
        't1'           => Models::Comment,
        't2'           => Models::User,
        't3'           => Models::Submission,
        't4'           => Models::PrivateMessage,
        't5'           => Models::Subreddit,
        'more'         => Models::MoreComments,
        'wikipage'     => Models::WikiPage,
        'Listing'      => Models::Listing,
        'modaction'    => Models::Subreddit::ModAction,
        'LabeledMulti' => Models::Multireddit,
        'LiveUpdate'   => Models::LiveThread::LiveUpdate
      }.freeze

      def initialize(client)
        @client = client
      end

      def unmarshal(response)
        if response[:json] && response[:json][:data]
          if response[:json][:data][:things]
            Models::Listing.new(@client, children: response[:json][:data][:things])
          else
            Models::BasicModel.new(@client, response[:json][:data])
          end
        elsif response[:kind]
          if MAPPING.key?(response[:kind])
            MAPPING[response[:kind]].new(@client, response[:data])
          else
            raise "unknown type to unmarshal: #{response[:kind].inspect}"
          end
        else
          response
        end
      end
    end
  end
end
