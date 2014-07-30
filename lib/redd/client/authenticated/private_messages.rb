module Redd
  module Client
  	class Authenticated
      module PrivateMessages
        def block_message(message)
          fullname = extract_fullname(message)
          send(:post, "/api/block", id: fullname)
        end

        def compose_message(to, subject, text, captcha = nil, identifier = nil)
          meth = :post
          path = "/api/compose"
          params = {
            api_type: "json", to: to.to_s, subject: subject, text: text
          }
          params << {captcha: captcha, iden: identifier} if captcha

          send(meth, path, params)
        end

        def mark_as_read(message)
          fullname = extract_fullname(message)
          send(:post, "/api/read_message", id: fullname)
        end

        def mark_as_unread(message)
          fullname = extract_fullname(message)
          send(:post, "/api/unread_message", id: fullname)
        end

        def messages(category = "inbox", params = {})
          meth = :get
          path = "/message/#{category}.json"

          object_from_response(meth, path, params)
        end
      end
    end
  end
end
