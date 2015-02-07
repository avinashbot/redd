require_relative "base"

module Redd
  module Objects
    # A reddit thing.
    # @see http://www.reddit.com/dev/api#fullnames
    class Thing < Base
      # Load up all the possible mixins for the thing.
      Dir.glob("./thing/*.rb") { |file| require(file) }

      # A constructor for API responses with the structure:
      # {kind: "t[1-5]", data: {id: "[1-9a-z]{6}", ...}}
      #
      # @param [Clients::Base] client The client instance.
      # @param [Hash] body The response body.
      def initialize(body = {}, client = Redd.client)
        @client = client
        merge_body!(body)
      end

      # Check for equality.
      # @param other The other object.
      # @return [Boolean]
      def ==(other)
        other.is_a?(Thing) && fullname == other.fullname
      end

      # @return [String] The fullname of the thing.
      def fullname
        self[:fullname] || "#{kind}_#{id}"
      end

      private

      def merge_body!(body)
        body[:data][:kind] = body[:kind]
        deep_merge!(body[:data])
      end

      def merge_response!(meth, path, params = {})
        body = client.send(meth, path, params).body
        attributes = (block_given? ? yield(body) : body)
        merge_body!(attributes)
      end
    end
  end
end
