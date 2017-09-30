# frozen_string_literal: true

require_relative 'user'

module Redd
  module Models
    # The user that the bot is running under.
    class Self < User
      # @!attribute [r] name
      #   @return [String] the logged-in user's username
      property :name, required: false

      private

      def lazer_reload
        fully_loaded!
        client.get('/api/v1/me').body
      end
    end
  end
end
