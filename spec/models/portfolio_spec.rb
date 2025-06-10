require 'rails_helper'

RSpec.describe Portfolio, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:portfolio_coins).dependent(:destroy) }
    it { should have_many(:coins).through(:portfolio_coins) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe '#total_value' do
    let(:portfolio) { create(:portfolio) }
    let(:coin1) { create(:coin, current_price: 45000.0) }
    let(:coin2) { create(:coin, current_price: 2000.0) }
    
    before do
      create(:portfolio_coin, portfolio: portfolio, coin: coin1, quantity: 2.0)
      create(:portfolio_coin, portfolio: portfolio, coin: coin2, quantity: 10.0)
    end

    it 'calculates the total value of all portfolio coins' do
      expect(portfolio.total_value).to eq(110000.0) # (2 * 45000) + (10 * 2000)
    end
  end

  describe '#total_profit_loss' do
    let(:portfolio) { create(:portfolio) }
    let(:coin) { create(:coin, current_price: 45000.0) }
    let(:portfolio_coin) do
      create(:portfolio_coin,
             portfolio: portfolio,
             coin: coin,
             quantity: 2.0,
             average_buy_price: 40000.0)
    end

    before { portfolio_coin }

    it 'calculates the total profit/loss' do
      expect(portfolio.total_profit_loss).to eq(10000.0) # 2 * (45000 - 40000)
    end
  end
end 