require 'rails_helper'

RSpec.describe PortfolioCoin, type: :model do
  describe 'associations' do
    it { should belong_to(:portfolio) }
    it { should belong_to(:coin) }
    it { should have_many(:transactions).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:average_buy_price) }
    it { should validate_numericality_of(:average_buy_price).is_greater_than(0) }
  end

  describe '#current_value' do
    let(:portfolio_coin) do
      create(:portfolio_coin,
             quantity: 2.5,
             coin: create(:coin, current_price: 45000.0))
    end

    it 'calculates the current value' do
      expect(portfolio_coin.current_value).to eq(112500.0) # 2.5 * 45000
    end
  end

  describe '#profit_loss' do
    let(:portfolio_coin) do
      create(:portfolio_coin,
             quantity: 2.0,
             average_buy_price: 40000.0,
             coin: create(:coin, current_price: 45000.0))
    end

    it 'calculates the profit/loss' do
      expect(portfolio_coin.profit_loss).to eq(10000.0) # 2 * (45000 - 40000)
    end
  end

  describe '#profit_loss_percentage' do
    let(:portfolio_coin) do
      create(:portfolio_coin,
             quantity: 2.0,
             average_buy_price: 40000.0,
             coin: create(:coin, current_price: 45000.0))
    end

    it 'calculates the profit/loss percentage' do
      expect(portfolio_coin.profit_loss_percentage).to eq(12.5) # ((45000 - 40000) / 40000) * 100
    end
  end

  describe '#update_after_transaction' do
    let(:portfolio_coin) { create(:portfolio_coin, quantity: 1.0, average_buy_price: 40000.0) }
    
    context 'when buying' do
      let(:transaction) do
        create(:transaction, :buy,
               portfolio_coin: portfolio_coin,
               quantity: 2.0,
               price: 45000.0)
      end

      before { portfolio_coin.update_after_transaction(transaction) }

      it 'updates quantity and average buy price' do
        expect(portfolio_coin.quantity).to eq(3.0)
        expect(portfolio_coin.average_buy_price).to eq(43333.33) # ((1 * 40000) + (2 * 45000)) / 3
      end
    end

    context 'when selling' do
      let(:transaction) do
        create(:transaction, :sell,
               portfolio_coin: portfolio_coin,
               quantity: 0.5,
               price: 45000.0)
      end

      before { portfolio_coin.update_after_transaction(transaction) }

      it 'updates quantity only' do
        expect(portfolio_coin.quantity).to eq(0.5)
        expect(portfolio_coin.average_buy_price).to eq(40000.0)
      end
    end
  end
end 