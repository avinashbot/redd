require_relative "thing"

module Redd
  module Objects
    # A comment that can be made on a link.
    class Comment < Thing
      include Thing::Editable
      include Thing::Inboxable
      include Thing::Moderatable
      include Thing::Saveable
      include Thing::Votable

      alias_property :reports_count, :num_reports
    end
  end
end
