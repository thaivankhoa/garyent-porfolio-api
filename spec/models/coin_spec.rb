require 'rails_helper'

RSpec.describe Coin, type: :model do
  describe 'associations' do
    it { should have_many(:portfolio_coins) }
    it { should have_many(:portfolios).through(:portfolio_coins) }
  end

  describe 'validations' do
    subject { build(:coin) }

    it { should validate_presence_of(:coingecko_id) }
    it { should validate_uniqueness_of(:coingecko_id) }
    it { should validate_presence_of(:symbol) }
    it { should validate_presence_of(:name) }
  end

  describe '.update_prices' do
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

    it 'updates coin prices from Coingecko' do
      Coin.update_prices

      bitcoin.reload
      ethereum.reload

      expect(bitcoin.current_price).to eq(46000.0)
      expect(bitcoin.market_cap).to eq(860000000000)
      expect(bitcoin.price_change_percentage_24h).to eq(3.5)

      expect(ethereum.current_price).to eq(2500.0)
      expect(ethereum.market_cap).to eq(300000000000)
      expect(ethereum.price_change_percentage_24h).to eq(2.8)
    end
  end
end 