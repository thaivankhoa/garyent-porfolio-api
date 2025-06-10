require 'rails_helper'

RSpec.describe PortfolioCoinSerializer do
  let(:portfolio_coin) do
    create(:portfolio_coin,
           quantity: 2.0,
           average_buy_price: 40000.0,
           coin: create(:coin, current_price: 45000.0))
  end

  subject { described_class.new(portfolio_coin).as_json }

  it 'includes basic portfolio coin attributes' do
    expect(subject[:data][:attributes]).to include(
      quantity: 2.0,
      average_buy_price: 40000.0
    )
  end

  it 'includes calculated values' do
    expect(subject[:data][:attributes]).to include(
      current_value: 90000.0, # 2 * 45000
      profit_loss: 10000.0, # 2 * (45000 - 40000)
      profit_loss_percentage: 12.5 # ((45000 - 40000) / 40000) * 100
    )
  end

  it 'includes coin relationship' do
    expect(subject[:data][:relationships]).to include(:coin)
    expect(subject[:data][:relationships][:coin][:data][:id].to_i).to eq(portfolio_coin.coin_id)
  end

  it 'includes transactions relationship' do
    expect(subject[:data][:relationships]).to include(:transactions)
  end
end 