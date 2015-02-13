require_relative "thing"

module Redd
  module Objects
    # The model for a reddit user
    class User < Thing
      include Thing::Messageable

      # @!method get_overview(**params)
      # @!method get_submitted(**params)
      # @!method get_comments(**params)
      # @!method get_liked(**params)
      # @!method get_disliked(**params)
      # @!method get_hidden(**params)
      # @!method get_saved(**params)
      # @!method get_gilded(**params)
      #
      # Get the appropriate listing.
      # @option params [String] :after Return results after the given
      #   fullname.
      # @option params [String] :before Return results before the given
      #   fullname.
      # @option params [Integer] :count The number of items already seen
      #   in the listing.
      # @option params [1..100] :limit The maximum number of things to
      #   return.
      # @option params [:hot, :new, :top, :controversial] :sort The type of
      #   sort to use.
      # @option params [:hour, :day, :week, :month, :year, :all] :t The
      #   time period to consider when sorting.
      # @option params [:given] :show For {#get_gilded}, whether to show the
      #   gildings given.
      # @note The option :t only applies to the top and controversial sorts.
      # @return [Listing<Submission>]
      %w(
        overview submitted comments liked disliked hidden saved gilded
      ).each do |type|
        define_method :"get_#{type}" do |**params|
          client.request_object(
            :get, "/user/#{name}/#{type}.json",
          )
        end
      end

      # Get posts that the user has gilded.
      # @see #get_gilded
      def get_gildings_given(**params)
        get_gilded(**params.merge(show: "given"))
      end
    end
  end
end
