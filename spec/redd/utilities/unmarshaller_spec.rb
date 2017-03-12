# frozen_string_literal: true

RSpec.describe Redd::Utilities::Unmarshaller do
  let(:unmarshaller) { Redd::Utilities::Unmarshaller.new(instance_double('Redd::APIClient')) }
  let(:thing) { { kind: 't2', data: { name: 'Mustermind' } } }

  describe '#unmarshal' do
    context 'when the response is in the format json->data->things' do
      it 'returns a listing' do
        listing = unmarshaller.unmarshal(json: { data: { things: [] } })
        expect(listing).to be_a(Redd::Models::Listing)
      end

      it "unmarshals the listing's contents" do
        listing = unmarshaller.unmarshal(json: { data: { things: [thing] } })
        expect(listing.first.name).to eq('Mustermind')
      end
    end

    context 'when the response is in the format json->data' do
      it 'returns a BasicModel' do
        model = unmarshaller.unmarshal(json: { data: thing[:data] })
        expect(model).to be_a(Redd::Models::BasicModel)
      end

      it 'retains the attributes from the data hash' do
        model = unmarshaller.unmarshal(json: { data: thing[:data] })
        expect(model.name).to eq('Mustermind')
      end
    end

    context "when the response kind is 'Listing'" do
      it 'returns a listing' do
        listing = unmarshaller.unmarshal(kind: 'Listing', data: { children: [] })
        expect(listing).to be_a(Redd::Models::Listing)
      end

      it "unmarshals the listing's contents" do
        listing = unmarshaller.unmarshal(kind: 'Listing', data: { children: [thing] })
        expect(listing.first.name).to eq('Mustermind')
      end
    end

    context 'when the response kind is known' do
      it 'returns the appropriate model' do
        model = unmarshaller.unmarshal(thing)
        expect(model.name).to eq('Mustermind')
      end
    end
  end
end
