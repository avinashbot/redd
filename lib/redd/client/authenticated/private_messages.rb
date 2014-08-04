module Redd
  module Client
    class Authenticated
      module PrivateMessages
        def block_message(message)
          fullname = extract_fullname(message)
          post "/api/block", id: fullname
        end

        def compose_message(to, subject, text, captcha = nil, identifier = nil)
          params = {
            api_type: "json", to: to.to_s, subject: subject, text: text
          }
          params << {captcha: captcha, iden: identifier} if captcha

          post "/api/compose", params
        end

        def mark_as_read(message)
          fullname = extract_fullname(message)
          post "/api/read_message", id: fullname
        end

        def mark_as_unread(message)
          fullname = extract_fullname(message)
          post "/api/unread_message", id: fullname
        end

        def messages(category = "inbox", params = {})
          object_from_response :get, "/message/#{category}.json", params
        end
      end
    end
  end
end
