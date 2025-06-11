require 'rails_helper'

RSpec.describe 'API V1 Coins', type: :request do
  let(:user) { create(:user) }
  let(:headers) { user.create_new_auth_token }
  let(:market_service) { instance_double(Coingecko::MarketService) }

  describe 'GET /api/v1/coins' do
    let!(:bitcoin) { create(:coin, :bitcoin) }
    let!(:ethereum) { create(:coin, :ethereum) }

    before do
      allow(Coingecko::MarketService).to receive(:new).and_return(market_service)
      allow(market_service).to receive(:sync_markets).and_return([
        {
          'id' => 'bitcoin',
          'symbol' => 'btc',
          'name' => 'Bitcoin',
          'current_price' => 105000.0,
          'market_cap' => 850000000000,
          'market_cap_rank' => 1,
          'total_volume' => 28000000000,
          'price_change_percentage_24h' => 2.5,
          'last_updated' => Time.current
        },
        {
          'id' => 'ethereum',
          'symbol' => 'eth',
          'name' => 'Ethereum',
          'current_price' => 2500.0,
          'market_cap' => 240000000000,
          'market_cap_rank' => 2,
          'total_volume' => 15000000000,
          'price_change_percentage_24h' => 1.8,
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
        expect(bitcoin_response['attributes']['current_price']).to eq(105000.0)
        expect(bitcoin_response['attributes']['price_change_percentage_24h']).to eq(2.5)

        ethereum_response = json_response['data'].find { |c| c['attributes']['coingecko_id'] == 'ethereum' }
        expect(ethereum_response['attributes']['current_price']).to eq(2500.0)
        expect(ethereum_response['attributes']['price_change_percentage_24h']).to eq(1.8)
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
        allow(market_service).to receive(:sync_markets)
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
      allow(Coingecko::MarketService).to receive(:new).and_return(market_service)
      allow(market_service).to receive(:sync_markets).with(['bitcoin']).and_return([
        {
          'id' => 'bitcoin',
          'symbol' => 'btc',
          'name' => 'Bitcoin',
          'current_price' => 105000.0,
          'market_cap' => 850000000000,
          'market_cap_rank' => 1,
          'total_volume' => 28000000000,
          'price_change_percentage_24h' => 2.5,
          'last_updated' => Time.current
        }
      ])
    end

    context 'when coin exists' do
      before { get "/api/v1/coins/#{coin.id}", headers: headers }

      it 'returns the coin with updated price' do
        expect(response).to have_http_status(:ok)
        expect(json_response['data']['id'].to_i).to eq(coin.id)
        expect(json_response['data']['attributes']['current_price']).to eq(105000.0)
        expect(json_response['data']['attributes']['price_change_percentage_24h']).to eq(2.5)
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
        allow(market_service).to receive(:sync_markets)
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