# frozen_string_literal: true

module Redd
  module Models
    # A model that can be messaged (i.e. Users and Subreddits).
    module Messageable
      # Compose a message to a person or the moderators of a subreddit.
      #
      # @param to [String] the thing to send the message to (overriden by User and Subreddit)
      # @param subject [String] the subject of the message
      # @param text [String] the message text
      # @param from [Subreddit, nil] the subreddit to send the message on behalf of
      def send_message(to:, subject:, text:, from: nil)
        params = { to: to, subject: subject, text: text }
        params[:from_sr] = from.display_name if from
        client.post('/api/compose', params)
      end
    end
  end
end
