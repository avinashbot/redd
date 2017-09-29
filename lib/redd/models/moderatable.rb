# frozen_string_literal: true

module Redd
  module Models
    # A model that can be managed by a moderator (i.e. Submissions and Comments).
    module Moderatable
      # Approve a submission.
      def approve
        client.post('/api/approve', id: read_attribute(:name))
      end

      # Remove a submission.
      # @param spam [Boolean] whether or not this item is removed due to it being spam
      def remove(spam: false)
        client.post('/api/remove', id: read_attribute(:name), spam: spam)
      end

      # Distinguish a link or comment with a sigil to show that it has been created by a moderator.
      # @param how [:yes, :no, :admin, :special, :sticky] how to distinguish the thing
      # @note :sticky is for comments. see {Submission#make_sticky} for posts.
      def distinguish(how = :yes)
        params = { id: read_attribute(:name), how: how }
        if how == :sticky
          params[:how] = :yes
          params[:sticky] = true
        end
        client.post('/api/distinguish', params)
      end

      # Remove the sigil that shows a thing was created by a moderator.
      def undistinguish
        distinguish(:no)
      end

      # Stop getting any moderator-related reports on the thing.
      def ignore_reports
        client.post('/api/ignore_reports', id: read_attribute(:name))
      end

      # Start getting moderator-related reports on the thing again.
      def unignore_reports
        client.post('/api/unignore_reports', id: read_attribute(:name))
      end
    end
  end
end
