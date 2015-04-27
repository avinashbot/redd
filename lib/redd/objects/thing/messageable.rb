module Redd
  module Objects
    class Thing
      # Things that can be sent a message.
      module Messageable
        # Compose a message to a person or the moderators of a subreddit.
        #
        # @param [String] subject The subject of the message.
        # @param [String] text The message text.
        # @param [String] from_sr The subreddit to send the message on behalf
        #   of or nil if from the user.
        # @param [String] captcha A possible captcha result to send if one
        #   is required.
        # @param [String] identifier The identifier for the captcha if one
        #   is required.
        def send_message(
          subject, text, from_sr = nil, captcha = nil, identifier = nil
        )
          params = {subject: subject, text: text}
          params.merge!(captcha: captcha, iden: identifier) if captcha
          params[:from_sr] = client.property(from_sr, :display_name) if from_sr
          params[:to] =
            if respond_to?(:display_name)
              "/r/#{self[:display_name]}"
            else
              self[:name]
            end

          post("/api/compose", params)
        end
      end
    end
  end
end
