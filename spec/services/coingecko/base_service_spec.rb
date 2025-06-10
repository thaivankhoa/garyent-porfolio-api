require 'rails_helper'

RSpec.describe Coingecko::BaseService do
  describe '.api_url' do
    it 'returns the base API URL' do
      expect(described_class.api_url).to eq('https://api.coingecko.com/api/v3')
    end
  end

  describe '.headers' do
    before do
      allow(ENV).to receive(:[]).with('COINGECKO_API_KEY').and_return('test-api-key')
    end

    it 'returns headers with API key' do
      expect(described_class.headers).to include(
        'x-cg-pro-api-key' => 'test-api-key'
      )
    end
  end

  describe '.get' do
    let(:endpoint) { '/coins/markets' }
    let(:params) { { vs_currency: 'usd' } }
    let(:response_body) { [{ id: 'bitcoin' }] }
    let(:response) { instance_double(HTTParty::Response, code: 200, parsed_response: response_body) }

    before do
      allow(HTTParty).to receive(:get).and_return(response)
    end

    it 'makes a GET request to the API' do
      result = described_class.get(endpoint, params)

      expect(HTTParty).to have_received(:get).with(
        "#{described_class.api_url}#{endpoint}",
        hash_including(
          query: params,
          headers: described_class.headers
        )
      )
      expect(result).to eq(response_body)
    end

    context 'when API returns an error' do
      let(:response) { instance_double(HTTParty::Response, code: 429, parsed_response: { error: 'Too many requests' }) }

      it 'raises an error' do
        expect {
          described_class.get(endpoint, params)
        }.to raise_error(Coingecko::BaseService::ApiError, 'API request failed: Too many requests')
      end
    end
  end
end 