require 'rails_helper'

RSpec.describe Coingecko::MarketService do
  describe '.fetch_market_data' do
    let(:coin_ids) { %w[bitcoin ethereum] }
    let(:market_data) do
      [
        {
          'id' => 'bitcoin',
          'symbol' => 'btc',
          'name' => 'Bitcoin',
          'current_price' => 45000.0,
          'market_cap' => 850000000000,
          'market_cap_rank' => 1,
          'total_volume' => 28000000000,
          'price_change_percentage_24h' => 2.5,
          'sparkline_in_7d' => { 'price' => [44000.0, 44500.0, 45000.0] },
          'last_updated' => Time.current.iso8601
        },
        {
          'id' => 'ethereum',
          'symbol' => 'eth',
          'name' => 'Ethereum',
          'current_price' => 2000.0,
          'market_cap' => 240000000000,
          'market_cap_rank' => 2,
          'total_volume' => 15000000000,
          'price_change_percentage_24h' => 1.8,
          'sparkline_in_7d' => { 'price' => [1900.0, 1950.0, 2000.0] },
          'last_updated' => Time.current.iso8601
        }
      ]
    end

    before do
      allow(described_class).to receive(:get).with(
        '/coins/markets',
        hash_including(
          vs_currency: 'usd',
          ids: coin_ids.join(','),
          sparkline: true
        )
      ).and_return(market_data)
    end

    it 'fetches market data for specified coins' do
      result = described_class.fetch_market_data(coin_ids)
      expect(result).to eq(market_data)
    end

    context 'when no coin_ids are provided' do
      let(:all_coins_data) { market_data + [{ 'id' => 'dogecoin', 'symbol' => 'doge' }] }

      before do
        allow(described_class).to receive(:get).with(
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
        result = described_class.fetch_market_data
        expect(result).to eq(all_coins_data)
      end
    end

    context 'when API request fails' do
      before do
        allow(described_class).to receive(:get).and_raise(Coingecko::BaseService::ApiError.new('API error'))
      end

      it 'raises an error' do
        expect {
          described_class.fetch_market_data(coin_ids)
        }.to raise_error(Coingecko::BaseService::ApiError, 'API error')
      end
    end
  end
end 