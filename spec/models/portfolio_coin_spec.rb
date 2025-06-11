require 'rails_helper'

RSpec.describe PortfolioCoin, type: :model do
  describe 'associations' do
    it { should belong_to(:portfolio) }
    it { should belong_to(:coin) }
    it { should have_many(:transactions).dependent(:destroy) }
  end

  let(:portfolio_coin) { create(:portfolio_coin) }
  let(:coin) { portfolio_coin.coin }

  describe '#total_quantity' do
    context 'when there are no transactions' do
      it 'returns 0' do
        expect(portfolio_coin.total_quantity).to eq(0)
      end
    end

    context 'when there are transactions' do
      before do
        create(:transaction, portfolio_coin: portfolio_coin, transaction_type: 'buy', quantity: 2.0)
        create(:transaction, portfolio_coin: portfolio_coin, transaction_type: 'buy', quantity: 1.5)
      end

      it 'returns the net quantity from all transactions' do
        expect(portfolio_coin.total_quantity).to eq(3.5) # 2.0 + 1.5
      end
    end
  end

  describe '#total_invested' do
    context 'when there are no transactions' do
      it 'returns 0' do
        expect(portfolio_coin.total_invested).to eq(0)
      end
    end

    context 'when there are buy transactions' do
      before do
        create(:transaction, portfolio_coin: portfolio_coin, transaction_type: 'buy', quantity: 2.0, price: 40000.0)
        create(:transaction, portfolio_coin: portfolio_coin, transaction_type: 'buy', quantity: 1.0, price: 50000.0)
      end

      it 'returns the total amount invested in buy transactions' do
        # (2.0 * 40000) + (1.0 * 50000) = 130000
        expect(portfolio_coin.total_invested).to eq(130000.0)
      end
    end

    context 'when there are both buy and sell transactions' do
      before do
        create(:transaction, portfolio_coin: portfolio_coin, transaction_type: 'buy', quantity: 2.0, price: 40000.0)
        create(:transaction, portfolio_coin: portfolio_coin, transaction_type: 'buy', quantity: 1.0, price: 50000.0)
        create(:transaction, portfolio_coin: portfolio_coin, transaction_type: 'sell', quantity: 1.0, price: 45000.0)
      end

      it 'only considers buy transactions for total invested' do
        # (2.0 * 40000) + (1.0 * 50000) = 130000
        expect(portfolio_coin.total_invested.to_f).to eq(130000.to_f)
      end
    end
  end

  describe '#average_buy_price' do
    context 'when there are no transactions' do
      it 'returns 0' do
        expect(portfolio_coin.average_buy_price).to eq(0)
      end
    end

    context 'when there are buy transactions' do
      before do
        create(:transaction, portfolio_coin: portfolio_coin, transaction_type: 'buy', quantity: 2.0, price: 40000.0)
        create(:transaction, portfolio_coin: portfolio_coin, transaction_type: 'buy', quantity: 1.0, price: 50000.0)
      end

      it 'returns the weighted average buy price' do
        # (2.0 * 40000 + 1.0 * 50000) / (2.0 + 1.0) = 43333.33
        expect(portfolio_coin.average_buy_price).to be_within(0.01).of(43333.33)
      end
    end
  end

  describe '#current_value' do
    before do
      coin.update(current_price: 45000.0)
      create(:transaction, portfolio_coin: portfolio_coin, transaction_type: 'buy', quantity: 2.0)
      create(:transaction, portfolio_coin: portfolio_coin, transaction_type: 'buy', quantity: 1.0)
      create(:transaction, portfolio_coin: portfolio_coin, transaction_type: 'sell', quantity: 0.5)
    end

    it 'returns the current value based on total quantity and current price' do
      # (2.0 + 1.0 - 0.5) * 45000 = 112500
      expect(portfolio_coin.reload.current_value).to eq(112500.0)
    end
  end

  describe '#gain_or_loss' do
    before do
      coin.update(current_price: 45000.0)
      create(:transaction, portfolio_coin: portfolio_coin, transaction_type: 'buy', quantity: 2.0, price: 40000.0)
      create(:transaction, portfolio_coin: portfolio_coin, transaction_type: 'buy', quantity: 1.0, price: 50000.0)
    end

    it 'returns the total gain or loss' do
      # Current value: (2.0 + 1.0) * 45000 = 135000
      # Total invested: (2.0 * 40000) + (1.0 * 50000) = 130000
      # Gain/Loss: 135000 - 130000 = 5000
      expect(portfolio_coin.reload.gain_or_loss.dig(:amount)).to eq(5000.0)
    end

    context 'when there is a loss' do
      before do
        coin.update(current_price: 35000.0)
      end

      it 'returns the negative difference' do
        # Current value: (2.0 + 1.0) * 35000 = 105000
        # Total invested: (2.0 * 40000) + (1.0 * 50000) = 130000
        # Gain/Loss: 105000 - 130000 = -25000
        expect(portfolio_coin.reload.gain_or_loss.dig(:amount)).to eq(25000.0)
        expect(portfolio_coin.reload.gain_or_loss.dig(:is_gain)).to eq(false)
      end
    end
  end
end 