module Redd
  module Objects
    class Thing
      # Things that can be saved to a user's account.
      module Saveable
        # Save a link or comment (if gilded) to the user's account.
        # @param [String] category A category to save to (if gilded).
        def save(category = nil)
          params = {id: fullname}
          params << {category: category} if category
          post("/api/save", params)
        end

        # Remove the link or comment from the user's saved links.
        def unsave
          post("/api/unsave", id: fullname)
        end
      end
    end
  end
end
