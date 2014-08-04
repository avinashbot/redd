module Redd
  module Client
    class Unauthenticated
      module Captcha
        def needs_captcha?
          get "/api/needs_captcha.json"
        end

        def new_captcha
          response = get "/api/new_captcha", api_type: "json"
          response[:json][:data][:iden]
        end

        def captcha_url(identifier)
          "http://www.reddit.com/captcha/#{identifier}.png"
        end
      end
    end
  end
end
