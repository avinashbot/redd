require "redd/oauth2_access"

module Redd
  module Client
    class OAuth2
      # Methods for obtaining an access token
      module Authorization
        # Build an authorization url to redirect the user to.
        #
        # @param scopes [Array<String>] The access scopes to request from the
        #   user.
        # @param duration [:temporary, :permanent] The duration of your access
        #   to the user's account.
        # @param state [String] A random string to check later.
        # @return [String] The url.
        #
        # @note The access tokens from both duration last only an hour, but you
        #   also get a refresh token when the duration is permanent.
        # @note You may be tempted to let the state remain "x", but seriously,
        #   use this; it helps prevent against CSRF attacks.
        def auth_url(scopes = ["identity"], duration = :temporary, state = "x")
          path = "https://ssl.reddit.com/api/v1/authorize"
          scope = scopes.is_a?(Array) ? scopes.join(",") : scopes
          query = {
            client_id: @client_id,
            redirect_uri: @redirect_uri,
            response_type: "code",
            state: state,
            scope: scope,
            duration: duration
          }
          string_query = query.map { |key, value| "#{key}=#{value}" }.join("&")
          "#{path}?#{string_query}"
        end

        # Request an access token from the code that is sent with the redirect.
        #
        # @param code [String] The code that was sent in the GET request.
        # @param set_access [Boolean] Whether to automatically use this token
        #   for all future requests with this client.
        # @return [Redd::OAuth2Access, nil] A package of the necessary
        #   information to access the user's information or nil if there was
        #   an error.
        # @todo Custom Errors for OAuth2
        def request_access(code, set_access = true)
          response = auth_connection.post "/api/v1/access_token",
                                          grant_type: "authorization_code",
                                          code: code,
                                          redirect_uri: @redirect_uri

          return nil if response.body.key?(:error)
          access = Redd::OAuth2Access.new(response.body)
          @access = access if set_access
          access
        end

        # Obtain a new access token using a refresh token.
        #
        # @param token [Redd::OAuth2Access, String, nil] The refresh token or
        #   OAuth2Access. If none is provided, it'll refresh the one the client
        #   is currently using.
        # @param set_access [Boolean] Whether to automatically use this token
        #   for all future requests with this client.
        # @return [Redd::OAuth2Access] The refreshed information.
        def refresh_access(token = nil, set_access = true)
          refresh_token = extract_attribute(token, :refresh_token)
          response = auth_connection.post "/api/v1/access_token",
                                          grant_type: "refresh_token",
                                          refresh_token: refresh_token

          case token
          when nil
            access.refresh(response.body)
          when Redd::OAuth2Access
            token.refresh(response.body)
          when ::String
            new_access = Redd::OAuth2Access.new(response.body)
            @access = new_access if set_access
            new_access
          end
        end

        # Dispose of an access or refresh token when you're done with it.
        #
        # @param access [Redd::OAuth2Access, String] The token to revoke.
        # @param remove_refresh_token [Boolean] Whether you intend to revoke a
        #   refresh token.
        def revoke_access(access, remove_refresh_token = nil)
          token = 
          if remove_refresh_token
            extract_attribute(access, :refresh_token)
          else
            extract_attribute(access, :access_token)
          end

          params = {token: token}

          if remove_refresh_token
            params[:token_type_hint] = true
          elsif remove_refresh_token == false
            params[:token_type_hint] = false
          end

          auth_connection.post "/api/v1/revoke_token", params
        end
      end
    end
  end
end
