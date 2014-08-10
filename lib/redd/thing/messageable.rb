require "redd/thing"

module Redd
  class Thing
    module Messageable
      def send_message(subject, text, captcha = nil, identifier = nil)
        to = case self
             when Redd::Object::Subreddit
               "/r/" + display_name
             when Redd::Object::User
               name
             end

        client.send_message(to, subject, text, captcha, identifier)
      end
    end
  end
end
