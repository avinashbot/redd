module Redd
  module Client
    class OAuth2
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

        def request_access_token(code, set_token = true)
          response = auth_connection.post "/api/v1/access_token",
            grant_type: "authorization_code", code: code,
            redirect_uri: @redirect_uri

          body = response.body
          @access_token = body[:access_token] if set_token
          @refresh_token = body[:refresh_token] if body[:refresh_token]
          body
        end

        def refresh_access_token(
          refresh_token = @refresh_token, set_token = true
        )
          response = auth_connection.post "/api/v1/access_token",
            grant_type: "refresh_token", refresh_token: refresh_token

          body = response.body
          @access_token = body[:access_token] if set_token
          body
        end
      end
    end
  end
end
