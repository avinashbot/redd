# frozen_string_literal: true

require_relative 'lazy_model'
require_relative 'inboxable'
require_relative 'replyable'

module Redd
  module Models
    # A private message
    class PrivateMessage < LazyModel
      include Inboxable
      include Replyable

      # Make a Message from its id.
      # @option hash [String] :id the post's id (e.g. abc123)
      # @return [Submission]
      def self.from_response(client, hash)
        # FIXME: This returns the entire conversation, not the specific message. Possible to search,
        #   because depth of replies is just one.
        super
      end
    end
  end
end
