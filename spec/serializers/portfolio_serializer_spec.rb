# require 'rails_helper'

# RSpec.describe PortfolioSerializer do
#   let(:portfolio) { create(:portfolio) }
#   let(:coin1) { create(:coin, current_price: 45000.0) }
#   let(:coin2) { create(:coin, current_price: 2000.0) }
#   let!(:portfolio_coin1) do
#     create(:portfolio_coin,
#            portfolio: portfolio,
#            coin: coin1,
#            quantity: 2.0,
#            average_buy_price: 40000.0)
#   end
#   let!(:portfolio_coin2) do
#     create(:portfolio_coin,
#            portfolio: portfolio,
#            coin: coin2,
#            quantity: 10.0,
#            average_buy_price: 1800.0)
#   end

#   subject { described_class.new(portfolio).as_json }

#   it 'includes basic portfolio attributes' do
#     expect(subject[:data][:attributes]).to include(
#       name: portfolio.name,
#       description: portfolio.description
#     )
#   end

#   it 'includes portfolio value calculations' do
#     expect(subject[:data][:attributes]).to include(
#       total_value: 110000.0, # (2 * 45000) + (10 * 2000)
#       total_profit_loss: 12000.0, # (2 * (45000 - 40000)) + (10 * (2000 - 1800))
#       total_profit_loss_percentage: 12.5 # (12000 / 96000) * 100
#     )
#   end

#   it 'includes portfolio coins relationship' do
#     expect(subject[:data][:relationships]).to include(:portfolio_coins)
#     expect(subject[:data][:relationships][:portfolio_coins][:data].length).to eq(2)
#   end
# end 