module Redd
  module Client
    class Unauthenticated
      # Methods to get captchas.
      # Many things like sending messages and posting links require captchas.
      module Captcha
        # @return [Boolean] Whether a captcha is required for some API methods.
        def needs_captcha?
          get "/api/needs_captcha.json"
        end

        # Create a new captcha identifier.
        # @return [String] The identifier.
        def new_captcha
          response = get "/api/new_captcha", api_type: "json"
          response[:json][:data][:iden]
        end

        # @param identifier [String] The captcha identifier.
        # @return The url for the captcha image.
        def captcha_url(identifier)
          "http://www.reddit.com/captcha/#{identifier}.png"
        end
      end
    end
  end
end
