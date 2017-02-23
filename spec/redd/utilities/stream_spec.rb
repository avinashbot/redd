# frozen_string_literal: true

describe Redd::Utilities::Stream do
  describe '#next_request' do
    it 'eliminates duplicate elements' do
      listing = [double(name: 'one'), double(name: 'two'), double(name: 'two'), double(name: 'one')]
      processed_messages = []
      Redd::Utilities::Stream.new { listing }.next_request { |e| processed_messages << e }
      expect(processed_messages.length).to eq(2)
    end
  end
end
