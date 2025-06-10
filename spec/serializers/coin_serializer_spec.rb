require 'rails_helper'

RSpec.describe CoinSerializer do
  let(:coin) do
    create(:coin,
           coingecko_id: 'bitcoin',
           symbol: 'btc',
           name: 'Bitcoin',
           current_price: 45000.0,
           market_cap: 850000000000,
           market_cap_rank: 1,
           total_volume: 28000000000,
           price_change_percentage_24h: 2.5,
           sparkline_7d: [44000.0, 44500.0, 45000.0],
           last_updated: Time.current)
  end

  subject { described_class.new(coin).as_json }

  it 'includes coin attributes' do
    expect(subject[:data][:attributes]).to include(
      coingecko_id: 'bitcoin',
      symbol: 'btc',
      name: 'Bitcoin',
      current_price: 45000.0,
      market_cap: 850000000000,
      market_cap_rank: 1,
      total_volume: 28000000000,
      price_change_percentage_24h: 2.5,
      sparkline_7d: [44000.0, 44500.0, 45000.0],
      last_updated: coin.last_updated.as_json
    )
  end

  it 'includes portfolio_coins relationship' do
    expect(subject[:data][:relationships]).to include(:portfolio_coins)
  end
end 