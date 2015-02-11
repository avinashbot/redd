require_relative "../../objects/base"
require_relative "../../objects/thing"
require_relative "../../objects/listing"
require_relative "../../objects/wiki_page"
require_relative "../../objects/more_comments"
require_relative "../../objects/comment"
require_relative "../../objects/user"
require_relative "../../objects/submission"
require_relative "../../objects/private_message"
require_relative "../../objects/subreddit"

module Redd
  module Clients
    class Base
      # Internal methods that make life easier.
      module Utilities
        # The kind strings and the objects that should be used for them.
        OBJECT_KINDS = {
          "Listing"  => Objects::Listing,
          "wikipage" => Objects::WikiPage,
          "more"     => Objects::MoreComments,
          "t1"       => Objects::Comment,
          "t2"       => Objects::User,
          "t3"       => Objects::Submission,
          "t4"       => Objects::PrivateMessage,
          "t5"       => Objects::Subreddit
        }

        # Get a given property of a given object.
        # @param [Objects::Base, String] object The object with the property.
        # @param [Symbol] property The property to get.
        def property(object, property)
          object.respond_to?(property) ? object.send(property) : object.to_s
        end

        # Request and create an object from the response.
        # @param [Symbol] meth The method to use.
        # @param [String] path The path to visit.
        # @param [Hash] params The data to send with the request.
        # @return [Objects::Base] The object returned from the request.
        def request_object(meth, path, params = {})
          body = send(meth, path, params).body
          object_from_body(body)
        end

        # Create an object instance with the correct attributes when given a
        # body.
        #
        # @param [Hash] body A JSON hash.
        # @return [Objects::Thing, Objects::Listing]
        # rubocop:disable Metrics/MethodLength
        def object_from_body(body)
          return nil unless body.is_a?(Hash) && body.key?(:kind)
          object = object_from_kind(body[:kind])
          flat = flatten_body(body)
          object.new(self, flat)
        end

        private

        # @param [String] kind A kind in the format /t[1-5]/.
        # @return [Objects::Thing, Objects::Listing] The appropriate object for
        #   a given kind. Raises an error if one isn't found.
        def object_from_kind(kind)
          OBJECT_KINDS.fetch(kind)
        rescue KeyError => error
          raise error, "Redd doesn't know about the `#{kind}` kind!"
        end

        # Take a multilevel body ({kind: "tx", data: {...}}) and flatten it
        # into something like {kind: "tx", ...}
        # @param [Hash] body The response body.
        # @return [Hash] The flattened hash.
        def flatten_body(body)
          data = body[:data]
          data[:kind] = body[:kind]
          data
        end
      end
    end
  end
end
