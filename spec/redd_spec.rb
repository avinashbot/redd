# frozen_string_literal: true

describe Redd do
  it 'memes' do
    stub_api(:get, '/meme', hello: 1).and_return(response(world: 2))
    expect(client.get('/meme', hello: 1)).to eq(response(world: 2))
  end
end
