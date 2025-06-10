require 'rails_helper'

RSpec.describe 'API V1 Coins', type: :request do
  let(:user) { create(:user) }
  let(:headers) { user.create_new_auth_token }

  describe 'GET /api/v1/coins' do
    let!(:bitcoin) { create(:coin, :bitcoin) }
    let!(:ethereum) { create(:coin, :ethereum) }

    before do
      allow(Coingecko::MarketService).to receive(:fetch_market_data).and_return([
        {
          'id' => 'bitcoin',
          'symbol' => 'btc',
          'name' => 'Bitcoin',
          'current_price' => 46000.0,
          'market_cap' => 860000000000,
          'market_cap_rank' => 1,
          'total_volume' => 29000000000,
          'price_change_percentage_24h' => 3.5,
          'sparkline_in_7d' => { 'price' => [44000.0, 45000.0, 46000.0] },
          'last_updated' => Time.current
        },
        {
          'id' => 'ethereum',
          'symbol' => 'eth',
          'name' => 'Ethereum',
          'current_price' => 2500.0,
          'market_cap' => 300000000000,
          'market_cap_rank' => 2,
          'total_volume' => 15000000000,
          'price_change_percentage_24h' => 2.8,
          'sparkline_in_7d' => { 'price' => [2300.0, 2400.0, 2500.0] },
          'last_updated' => Time.current
        }
      ])
    end

    context 'when requesting all coins' do
      before { get '/api/v1/coins', headers: headers }

      it 'returns all coins with updated prices' do
        expect(response).to have_http_status(:ok)
        expect(json_response['data'].length).to eq(2)
        
        bitcoin_response = json_response['data'].find { |c| c['attributes']['coingecko_id'] == 'bitcoin' }
        expect(bitcoin_response['attributes']['current_price']).to eq(46000.0)
        expect(bitcoin_response['attributes']['price_change_percentage_24h']).to eq(3.5)

        ethereum_response = json_response['data'].find { |c| c['attributes']['coingecko_id'] == 'ethereum' }
        expect(ethereum_response['attributes']['current_price']).to eq(2500.0)
        expect(ethereum_response['attributes']['price_change_percentage_24h']).to eq(2.8)
      end
    end

    context 'when searching coins' do
      before { get '/api/v1/coins?search=bit', headers: headers }

      it 'returns matching coins' do
        expect(response).to have_http_status(:ok)
        expect(json_response['data'].length).to eq(1)
        expect(json_response['data'].first['attributes']['coingecko_id']).to eq('bitcoin')
      end
    end

    context 'when API request fails' do
      before do
        allow(Coingecko::MarketService).to receive(:fetch_market_data)
          .and_raise(Coingecko::BaseService::ApiError.new('API error'))
        get '/api/v1/coins', headers: headers
      end

      it 'returns service unavailable' do
        expect(response).to have_http_status(:service_unavailable)
        expect(json_response['errors']).to include(hash_including('detail' => 'API error'))
      end
    end
  end

  describe 'GET /api/v1/coins/:id' do
    let(:coin) { create(:coin, :bitcoin) }

    before do
      allow(Coingecko::MarketService).to receive(:fetch_market_data).with(['bitcoin']).and_return([
        {
          'id' => 'bitcoin',
          'symbol' => 'btc',
          'name' => 'Bitcoin',
          'current_price' => 46000.0,
          'market_cap' => 860000000000,
          'market_cap_rank' => 1,
          'total_volume' => 29000000000,
          'price_change_percentage_24h' => 3.5,
          'sparkline_in_7d' => { 'price' => [44000.0, 45000.0, 46000.0] },
          'last_updated' => Time.current
        }
      ])
    end

    context 'when coin exists' do
      before { get "/api/v1/coins/#{coin.id}", headers: headers }

      it 'returns the coin with updated price' do
        expect(response).to have_http_status(:ok)
        expect(json_response['data']['id'].to_i).to eq(coin.id)
        expect(json_response['data']['attributes']['current_price']).to eq(46000.0)
        expect(json_response['data']['attributes']['price_change_percentage_24h']).to eq(3.5)
      end
    end

    context 'when coin does not exist' do
      before { get '/api/v1/coins/0', headers: headers }

      it 'returns not found' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when API request fails' do
      before do
        allow(Coingecko::MarketService).to receive(:fetch_market_data)
          .and_raise(Coingecko::BaseService::ApiError.new('API error'))
        get "/api/v1/coins/#{coin.id}", headers: headers
      end

      it 'returns service unavailable' do
        expect(response).to have_http_status(:service_unavailable)
        expect(json_response['errors']).to include(hash_including('detail' => 'API error'))
      end
    end
  end
end 