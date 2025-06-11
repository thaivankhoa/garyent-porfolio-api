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
    let(:coin1) { create(:coin, coingecko_id: 'bitcoin', current_price: 45000.0) }
    let(:coin2) { create(:coin, coingecko_id: 'ethereum', current_price: 2000.0) }
    let(:portfolio_coin1) { create(:portfolio_coin, portfolio: portfolio, coin: coin1) }
    let(:portfolio_coin2) { create(:portfolio_coin, portfolio: portfolio, coin: coin2) }
    
    before do
      create(:transaction, portfolio_coin: portfolio_coin1, transaction_type: 'buy', quantity: 2, price: 45000)
      create(:transaction, portfolio_coin: portfolio_coin2, transaction_type: 'buy', quantity: 2, price: 2000)
    end

    it 'calculates the total value of all portfolio coins' do
      expect(portfolio.total_value).to eq(94000.to_f) # 45000 * 2 + 2000 * 2
    end
  end

  describe '#gain_or_loss' do
    let(:portfolio) { create(:portfolio) }
    let(:coin) { create(:coin, current_price: 45000.0) }
    let(:portfolio_coin) do
      create(:portfolio_coin,
             portfolio: portfolio,
             coin: coin,
            )
    end

    before do
      create(:transaction, portfolio_coin: portfolio_coin, transaction_type: 'buy', quantity: 1, price: 40000.0)
    end

    it 'calculates the total profit/loss' do
      expect(portfolio.gain_or_loss.dig(:amount)).to eq(5000.to_f)
      expect(portfolio.gain_or_loss.dig(:is_gain)).to eq(true)
      expect(portfolio.gain_or_loss.dig(:percentage)).to eq(12.5.to_f)
    end
  end
end
