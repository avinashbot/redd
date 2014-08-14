require "redd/thing"

module Redd
  class Thing
    # A Redd::Object that can be sent a message
    module Messageable
      def send_message(subject, text, captcha = nil, identifier = nil)
        client.send_message(self, subject, text, captcha, identifier)
      end
    end
  end
end
