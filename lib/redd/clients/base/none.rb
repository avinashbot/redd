module Redd
  module Clients
    class Base
      # Methods that don't require any scope.
      module None
        # @return [Boolean] Whether a captcha is required for some API methods.
        def needs_captcha?
          get("/api/needs_captcha.json").body == "true"
        end

        # Create a new captcha identifier.
        # @return [String] The identifier.
        # @todo Maybe create some kind of set_captcha!(...) method for the
        #   client to send automatically with the next response.
        def new_captcha
          post("/api/new_captcha").body[:json][:data][:iden]
        end

        # @param iden [String] The captcha identifier.
        # @return The url for the captcha image.
        def captcha_url(iden)
          "http://www.reddit.com/captcha/#{identifier}.png"
        end
      end
    end
  end
end
