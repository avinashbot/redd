# frozen_string_literal: true

RSpec.describe Redd::Utilities::Stream do
  describe '#next_request' do
    it 'calls the loader with the latest processed request' do
      first_listing = true
      stream = Redd::Utilities::Stream.new do |latest|
        if first_listing
          first_listing = false
          Redd::Models::Listing.new(nil, children: [double(name: 'newer'), double(name: 'new')])
        else
          expect(latest).to eq('newer')
          Redd::Models::Listing.new(nil, children: [])
        end
      end
      stream.next_request {}
      stream.next_request {}
    end

    it 'calls the yielded block in the reverse order' do
      expected_order = %w[new newer]
      stream = Redd::Utilities::Stream.new do
        Redd::Models::Listing.new(nil, children: [double(name: 'newer'), double(name: 'new')])
      end
      stream.next_request do |el|
        expect(el.name).to eq(expected_order.shift)
      end
    end

    it 'eliminates duplicate elements' do
      listing = [double(name: 'one'), double(name: 'two'), double(name: 'two'), double(name: 'one')]
      processed_messages = []
      Redd::Utilities::Stream.new { Redd::Models::Listing.new(nil, children: listing) }
                             .next_request { |e| processed_messages << e }
      expect(processed_messages.length).to eq(2)
    end
  end
end
