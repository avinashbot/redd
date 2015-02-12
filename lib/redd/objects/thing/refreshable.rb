module Redd
  module Objects
    class Thing
      # Things that can be refreshed with the current data.
      module Refreshable
        # Refresh the thing.
        def refresh!
          body = get("/api/info", id: fullname).body[:data][:children][0]
          deep_merge!(body[:data])
        end
      end
    end
  end
end
