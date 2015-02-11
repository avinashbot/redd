module Redd
  module Objects
    class Thing
      # Things that a moderator can manage.
      module Moderatable
        # Approve a submission.
        def approve
          post("/api/approve", id: fullname)
        end

        # Remove a submission.
        # @param [Boolean] spam Whether or not this item is removed due to it
        #   being spam.
        def remove(spam = false)
          post("/api/remove", id: fullname, spam: spam)
        end

        # Distinguish a link or comment with a sigil to show that it has
        # been created by a moderator.
        # @param [:yes, :no, :admin, :special] how How to distinguish the
        #   thing.
        def distinguish(how = :yes)
          post("/api/distinguish", id: fullname, how: how)
        end

        # Remove the sigil that shows a thing was created by a moderator.
        def undistinguish
          distinguish(thing, :no)
        end

        # Stop getting any moderator-related reports on the thing.
        def ignore_reports
          post("/api/ignore_reports", id: fullname)
        end

        # Start getting moderator-related reports on the thing again.
        def unignore_reports
          post("/api/unignore_reports", id: fullname)
        end
      end
    end
  end
end
