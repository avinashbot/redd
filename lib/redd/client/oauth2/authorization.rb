require "redd/oauth2_access"

module Redd
  module Client
    class OAuth2
      # Methods for obtaining an access token
      module Authorization
        def auth_url(scope = ["identity"], duration = "temporary", state = "x")
          path = "https://ssl.reddit.com/api/v1/authorize"
          query = {
            client_id: @client_id,
            redirect_uri: @redirect_uri,
            response_type: "code",
            state: state,
            scope: scope.join(","),
            duration: duration
          }
          string_query = query.map { |key, value| "#{key}=#{value}" }.join("&")
          "#{path}?#{string_query}"
        end

        def request_access_token(code, set_access = true)
          response = auth_connection.post "/api/v1/access_token",
                                          grant_type: "authorization_code",
                                          code: code,
                                          redirect_uri: @redirect_uri

          access = Redd::OAuth2Access.new(response.body)
          @access = access if set_access
          access
        end

        def refresh_access_token(access = nil, set_access = true)
          refresh_token = extract_attribute(access, :refresh_token)
          response = auth_connection.post "/api/v1/access_token",
                                          grant_type: "refresh_token",
                                          refresh_token: refresh_token

          case access
          when Redd::OAuth2Access
            access.refresh(response.body)
          when ::String
            new_access = Redd::OAuth2Access.new(response.body)
            @access = new_access if set_access
            new_access
          end
        end
      end
    end
  end
end
