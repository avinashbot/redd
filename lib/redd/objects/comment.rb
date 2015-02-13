require_relative "thing"

module Redd
  module Objects
    # A comment that can be made on a link.
    class Comment < Thing
      include Thing::Editable
      include Thing::Inboxable
      include Thing::Moderatable
      include Thing::Refreshable
      include Thing::Saveable
      include Thing::Votable

      alias_property :reports_count, :num_reports

      # @return [Listing] The comment's replies.
      def replies
        @replies ||= client.object_from_body(self[:replies])
      end
    end
  end
end
