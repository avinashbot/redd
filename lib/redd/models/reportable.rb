# frozen_string_literal: true

module Redd
  module Models
    # Things that can be reported (except users).
    module Reportable
      # Report the object.
      # @param reason [String] the report reason
      def report(reason)
        client.post('/api/report', thing_id: read_attribute(:name), reason: reason)
      end
    end
  end
end
