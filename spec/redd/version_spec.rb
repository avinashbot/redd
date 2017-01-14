# frozen_string_literal: true

describe 'Redd::VERSION' do
  it 'is a semantic version number' do
    expect(Redd::VERSION).to match(/^\d+\.\d+\.\d+(\.\w+\.\d+)?$/)
  end
end
