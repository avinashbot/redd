module Redd
  module Client
    class Unauthenticated
      module Captcha
        def needs_captcha?
          meth = :get
          path = "/api/needs_captcha.json"

          send(meth, path).body
        end

        def new_captcha
          meth = :post
          path = "/api/new_captcha"
          params = {api_type: "json"}

          response = send(meth, path, params).body
          response[:json][:data][:iden]
        end

        def captcha_url(identifier)
          "http://www.reddit.com/captcha/#{identifier}.png"
        end
      end
    end
  end
end
