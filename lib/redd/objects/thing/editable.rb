module Redd
  module Objects
    class Thing
      # Things that can be edited and deleted.
      module Editable
        # Edit a thing.
        # @param text [String] The new text.
        # @return [Redd::Thing] The edited thing.
        def edit(text)
          response = post("/api/editusertext", thing_id: fullname, text: text)
          self[(self.is_a?(Submission) ? :selftext : :body)] = text
          self
        end

        # Delete the thing
        def delete!
          post("/api/del", id: fullname)
        end
      end
    end
  end
end
