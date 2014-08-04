module Redd
  module Client
    class Authenticated
      module LinksComments
        def add_comment(thing, text, return_element = true)
          fullname = extract_fullname(thing)

          meth = :post
          path = "/api/comment"
          params = {api_type: "json", text: text, thing_id: fullname}

          # TODO: Return the created object.
          send(meth, path, params)
        end

        alias_method :reply, :add_comment

        def delete(thing)
          fullname = extract_fullname(thing)

          meth = :post
          path = "/api/del"
          params = {id: fullname}

          send(meth, path, params)
        end

        def edit(thing, text)
          fullname = extract_fullname(thing)

          meth = :post
          path = "/api/editusertext"
          params = {api_type: "json", text: text, thing_id: fullname}

          # TODO: Return the edited object.
          send(meth, path, params)
        end

        def hide(thing)
          fullname = extract_fullname(thing)

          meth = :post
          path = "/api/hide"
          params = {id: fullname}

          send(meth, path, params)
        end

        def unhide(thing)
          fullname = extract_fullname(thing)

          meth = :post
          path = "/api/unhide"
          params = {id: fullname}

          send(meth, path, params)
        end

        def mark_as_nsfw(thing)
          fullname = extract_fullname(thing)

          meth = :post
          path = "/api/marknsfw"
          params = {id: fullname}

          send(meth, path, params)
        end

        def unmark_as_nsfw(thing)
          fullname = extract_fullname(thing)

          meth = :post
          path = "/api/unmarknsfw"
          params = {id: fullname}

          send(meth, path, params)
        end

        alias_method :mark_as_safe, :unmark_as_nsfw

        def report(thing)
          fullname = extract_fullname(thing)

          meth = :post
          path = "/api/report"
          params = {id: fullname}

          send(meth, path, params)
        end

        def save(thing, category = nil)
          fullname = extract_fullname(thing)

          meth = :post
          path = "/api/save"
          params = {id: fullname}
          params << {category: category} if category

          send(meth, path, params)
        end

        def unsave(thing)
          fullname = extract_fullname(thing)

          meth = :post
          path = "/api/unsave"
          params = {id: fullname}

          send(meth, path, params)
        end

        def upvote(thing)
          vote(thing, 1)
        end

        def downvote(thing)
          vote(thing, -1)
        end

        def unvote(thing)
          vote(thing, 0)
        end

        private

        def vote(thing, direction)
          fullname = extract_fullname(thing)

          meth = :post
          path = "/api/vote"
          params = {id: fullname, dir: direction}

          send(meth, path, params)
        end
      end
    end
  end
end
