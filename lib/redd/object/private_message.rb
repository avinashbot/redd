require "redd/thing"

module Redd
  module Object
    # The model for private messages
    class PrivateMessage < Redd::Thing
      require "redd/thing/inboxable"

      include Redd::Thing::Inboxable

      attr_reader :body
      attr_reader :body_html
      attr_reader :subreddit
      attr_reader :parent_id
      attr_reader :distinguished
      attr_reader :was_comment
      attr_reader :first_message_name
      attr_reader :context

      attr_reader :dest
      attr_reader :author

      alias_method :from, :author
      alias_method :to, :dest

      def created
        @created ||= Time.at(@attributes[:created_utc])
      end

      def replies
        @replies ||= client.objects_from_listing(@attributes[:replies])
      end
    end
  end
end
