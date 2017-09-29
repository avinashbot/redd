# frozen_string_literal: true

module Redd
  module Models
    # Applied to {Session} for site-wide and {Subreddit} for subreddit-specific search.
    module Searchable
      # Search reddit.
      # @see https://www.reddit.com/wiki/search
      #
      # @param query [String] the search query
      # @param params [Hash] the search params
      # @option params [:cloudsearch, :lucene, :plain] :syntax the query's syntax
      # @option params [String] :after return results after the given fullname
      # @option params [String] :before return results before the given fullname
      # @option params [Integer] :count the number of items already seen in the listing
      # @option params [1..100] :limit the maximum number of things to return
      # @option params [:hour, :day, :week, :month, :year, :all] :time the time period to restrict
      #   search results by
      # @option params [:relevance, :hot, :top, :new, :comments] :sort the sort order of results
      # @option params [String] :restrict_to restrict by subreddit (prefer {Subreddit#search})
      # @return [Listing<Comment, Submission>] the search results
      def search(query, **params)
        params[:q] = query
        params[:t] = params.delete(:time) if params.key?(:time)
        if params[:restrict_to]
          subreddit = params.delete(:restrict_to)
          params[:restrict_sr] = true
          client.model(:get, "/r/#{subreddit}/search", params)
        else
          client.model(:get, '/search', params)
        end
      end
    end
  end
end
