require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'associations' do
    it { should belong_to(:portfolio_coin) }
  end

  describe 'validations' do
    it { should validate_presence_of(:transaction_type) }
    it { should validate_inclusion_of(:transaction_type).in_array(%w[buy sell]) }
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than(0) }
    it { should validate_presence_of(:executed_at) }
  end

  describe 'callbacks' do
    describe 'after_create' do
      let(:portfolio_coin) { create(:portfolio_coin, quantity: 1.0, average_buy_price: 40000.0) }
      
      context 'when buying' do
        let(:transaction) do
          build(:transaction, :buy,
                portfolio_coin: portfolio_coin,
                quantity: 2.0,
                price: 45000.0)
        end

        it 'updates portfolio_coin after creation' do
          expect { transaction.save }.to change { portfolio_coin.reload.quantity }.from(1.0).to(3.0)
          expect(portfolio_coin.average_buy_price).to eq(43333.33)
        end
      end

      context 'when selling' do
        let(:transaction) do
          build(:transaction, :sell,
                portfolio_coin: portfolio_coin,
                quantity: 0.5,
                price: 45000.0)
        end

        it 'updates portfolio_coin after creation' do
          expect { transaction.save }.to change { portfolio_coin.reload.quantity }.from(1.0).to(0.5)
          expect(portfolio_coin.average_buy_price).to eq(40000.0)
        end
      end

      context 'when selling more than available' do
        let(:transaction) do
          build(:transaction, :sell,
                portfolio_coin: portfolio_coin,
                quantity: 1.5,
                price: 45000.0)
        end

        it 'is invalid' do
          expect(transaction).not_to be_valid
          expect(transaction.errors[:quantity]).to include('cannot be greater than available quantity')
        end
      end
    end
  end
end 