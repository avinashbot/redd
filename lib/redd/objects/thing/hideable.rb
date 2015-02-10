module Redd
  module Objects
    class Thing
      # Things that can be hidden from the user.
      module Hideable
        # Hide a link from the user.
        def hide
          post("/api/hide", id: fullname)
        end

        # Unhide a previously hidden link.
        def unhide(thing)
          post("/api/unhide", id: fullname)
        end
      end
    end
  end
end
