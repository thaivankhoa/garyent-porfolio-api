require 'rails_helper'

RSpec.describe Coingecko::BaseService do
  let(:service) { described_class.new }
  let(:base_url) { 'https://api.coingecko.com' }
  let(:api_key) { ENV.fetch('COINGECKO_API_KEY', 'test-api-key') }

  describe '#build_url' do
    it 'builds URL with path' do
      url = service.send(:build_url, '/coins/markets')
      expect(url.to_s).to eq("#{base_url}/coins/markets")
    end

    it 'builds URL with params' do
      url = service.send(:build_url, '/coins/markets', { vs_currency: 'usd' })
      expect(url.to_s).to eq("#{base_url}/coins/markets?vs_currency=usd")
    end
  end

  describe '#build_request' do
    let(:url) { URI.parse("#{base_url}/coins/markets") }

    it 'builds request with headers' do
      request = service.send(:build_request, url)
      expect(request['accept']).to eq('application/json')
      expect(request['x-cg-api-key']).to eq(api_key)
    end
  end

  describe '#get' do
    let(:path) { '/coins/markets' }
    let(:params) { { vs_currency: 'usd' } }
    let(:response_body) { [{ id: 'bitcoin' }].to_json }
    let(:mock_http) { instance_double(Net::HTTP) }
    let(:mock_response) { instance_double(Net::HTTPResponse, code: '200', body: response_body) }

    before do
      allow(Net::HTTP).to receive(:new).and_return(mock_http)
      allow(mock_http).to receive(:use_ssl=)
      allow(mock_http).to receive(:read_timeout=)
      allow(mock_http).to receive(:open_timeout=)
      allow(mock_http).to receive(:request).and_return(mock_response)
    end

    it 'makes a GET request and returns parsed JSON' do
      result = service.send(:get, path, params)
      expect(result).to eq([{ 'id' => 'bitcoin' }])
    end

    context 'when API returns an error' do
      let(:mock_response) { instance_double(Net::HTTPResponse, code: '429', body: '{"error": "Rate limit exceeded"}') }

      it 'raises Error for 429' do
        expect {
          service.send(:get, path, params)
        }.to raise_error(Coingecko::BaseService::Error, /Rate limit exceeded/)
      end
    end

    context 'when connection fails' do
      before do
        allow(mock_http).to receive(:request).and_raise(Net::ReadTimeout)
      end

      it 'raises ConnectionError' do
        expect {
          service.send(:get, path, params)
        }.to raise_error(Coingecko::BaseService::ConnectionError, /Connection failed/)
      end
    end
  end
end
