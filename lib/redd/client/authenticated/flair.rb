module Redd
  module Client
    class Authenticated
      module Flair
        def get_flair_list(subreddit, params = {})
          name = extract_attribute(subreddit, :display_name)

          path = "/api/flairlist.json"
          path = path.prepend("/r/#{name}")

          get(path, params)[:users]
        end

        # @see http://ruby-doc.org/core-1.9.3/String.html#method-i-casecmp
        def get_flair(subreddit, user)
          username = extract_attribute(user, :name)
          options = {name: username}

          flair = get_flair_list(subreddit, options).first
          flair if flair[:user].casecmp(username.downcase) == 0
        end

        def set_flair(subreddit, user_or_link, text = "", css_class = "")
          name = extract_attribute(subreddit, :display_name)

          path = "/api/flair"
          path = path.prepend("/r/#{name}")
          params = {api_type: "json", text: text, css_class: css_class}

          case user_or_link
          when Redd::Object::User
            params[:name] = extract_attribute(user_or_link, :name)
          when Redd::Object::Submission
            params[:link] = extract_attribute(user_or_link, :display_name)
          else
            fail "You should provide a User or Submission object."
          end

          post path, params
        end
      end
    end
  end
end
