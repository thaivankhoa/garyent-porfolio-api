require 'rails_helper'

RSpec.describe Coingecko::MarketService do
  let(:service) { described_class.new }
  let(:coin_ids) { %w[bitcoin ethereum] }
  let(:market_data) do
    [
      {
        'id' => 'bitcoin',
        'symbol' => 'btc',
        'name' => 'Bitcoin',
        'current_price' => 105000.0,
        'market_cap' => 850000000000,
        'market_cap_rank' => 1,
        'total_volume' => 28000000000,
        'price_change_percentage_24h' => 2.5,
        'last_updated' => Time.current.iso8601
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
        'last_updated' => Time.current.iso8601
      }
    ]
  end

  describe '#fetch_markets' do
    before do
      allow(service).to receive(:get).with(
        '/coins/markets',
        hash_including(
          vs_currency: 'usd',
          ids: coin_ids.join(','),
          sparkline: true
        )
      ).and_return(market_data)
    end

    it 'fetches market data for specified coins' do
      result = service.fetch_markets(coin_ids)
      expect(result).to eq(market_data)
    end

    context 'when no coin_ids are provided' do
      let(:all_coins_data) { market_data + [{ 'id' => 'dogecoin', 'symbol' => 'doge' }] }

      before do
        allow(service).to receive(:get).with(
          '/coins/markets',
          hash_including(
            vs_currency: 'usd',
            order: 'market_cap_desc',
            per_page: 250,
            sparkline: true
          )
        ).and_return(all_coins_data)
      end

      it 'fetches market data for all top coins' do
        result = service.fetch_markets
        expect(result).to eq(all_coins_data)
      end
    end

    context 'when API request fails' do
      before do
        allow(service).to receive(:get).and_raise(Coingecko::BaseService::ApiError.new('API error'))
      end

      it 'raises an error' do
        expect {
          service.fetch_markets(coin_ids)
        }.to raise_error(Coingecko::BaseService::ApiError, 'API error')
      end
    end
  end

  describe '#sync_markets' do
    let!(:bitcoin) { create(:coin, :bitcoin) }
    let!(:ethereum) { create(:coin, :ethereum) }

    before do
      allow(service).to receive(:fetch_markets).and_return(market_data)
    end

    it 'updates existing coins with market data' do
      service.sync_markets

      bitcoin.reload
      ethereum.reload

      expect(bitcoin.current_price).to eq(105000.0)
      expect(bitcoin.market_cap).to eq(850000000000)
      expect(bitcoin.price_change_percentage_24h).to eq(2.5)

      expect(ethereum.current_price).to eq(2500.0)
      expect(ethereum.market_cap).to eq(240000000000)
      expect(ethereum.price_change_percentage_24h).to eq(1.8)
    end

    context 'when API request fails' do
      before do
        allow(service).to receive(:fetch_markets).and_raise(Coingecko::BaseService::ApiError.new('API error'))
      end

      it 'raises an error' do
        expect {
          service.sync_markets
        }.to raise_error(Coingecko::BaseService::ApiError, 'API error')
      end
    end
  end
end 