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

      # Delete the message from the user's inbox.
      def delete
        @client.post('/api/del_msg', id: get_attribute(:name))
      end

      private

      def default_loader
        # FIXME: This returns the entire conversation, not the specific message. Possible to search,
        #   because depth of replies is just one.
        {}
      end
    end
  end
end
