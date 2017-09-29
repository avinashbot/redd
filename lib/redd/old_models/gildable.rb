# frozen_string_literal: true

module Redd
  module Models
    # A model that can be gilded.
    module Gildable
      # Gift a user one month of reddit gold for their link or comment.
      def gild
        @client.post("/api/v1/gold/gild/#{get_attribute(:name)}")
      end
    end
  end
end
