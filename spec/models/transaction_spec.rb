require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'associations' do
    it { should belong_to(:portfolio_coin) }
  end

  describe 'validations' do
    let(:portfolio_coin) { create(:portfolio_coin) }
    
    context 'basic validations' do
      subject { build(:transaction, portfolio_coin: portfolio_coin, transaction_type: 'buy') }

      it { should validate_presence_of(:transaction_type) }
      it { should validate_presence_of(:quantity) }
      it { should validate_presence_of(:price) }
      
      it 'validates numericality of quantity' do
        transaction = Transaction.new(
          portfolio_coin: portfolio_coin,
          transaction_type: 'buy',
          quantity: 0,
          price: 1000.0,
          transaction_date: Time.current
        )
        expect(transaction).not_to be_valid
        expect(transaction.errors[:quantity]).to include("must be greater than 0")
      end

      it 'validates numericality of price' do
        transaction = Transaction.new(
          portfolio_coin: portfolio_coin,
          transaction_type: 'buy',
          quantity: 1.0,
          price: -1,
          transaction_date: Time.current
        )
        expect(transaction).not_to be_valid
        expect(transaction.errors[:price]).to include("must be greater than or equal to 0")
      end
    end

    context 'transaction_type enum' do
      it 'allows buy' do
        transaction = build(:transaction, portfolio_coin: portfolio_coin, transaction_type: 'buy')
        expect(transaction).to be_valid
      end

      it 'allows sell with sufficient balance' do
        create(:transaction, portfolio_coin: portfolio_coin, transaction_type: 'buy', quantity: 2.0)
        transaction = build(:transaction, portfolio_coin: portfolio_coin, transaction_type: 'sell', quantity: 1.0)
        expect(transaction).to be_valid
      end

      it 'does not allow other values' do
        expect {
          build(:transaction, portfolio_coin: portfolio_coin, transaction_type: 'invalid')
        }.to raise_error(ArgumentError, "'invalid' is not a valid transaction_type")
      end
    end

    context 'when selling' do
      let!(:buy_transaction) { create(:transaction, portfolio_coin: portfolio_coin, transaction_type: 'buy', quantity: 2.0) }
      
      context 'with sufficient balance' do
        subject { build(:transaction, portfolio_coin: portfolio_coin, transaction_type: 'sell', quantity: 1.0) }
        
        it 'is valid' do
          expect(subject).to be_valid
        end
      end

      context 'with insufficient balance' do
        subject { build(:transaction, portfolio_coin: portfolio_coin, transaction_type: 'sell', quantity: 3.0) }
        
        it 'is invalid' do
          expect(subject).not_to be_valid
          expect(subject.errors[:quantity]).to include("exceeds available balance")
        end
      end
    end
  end

  describe 'callbacks' do
    describe 'after_create' do
      let(:portfolio_coin) { create(:portfolio_coin) }
      let(:coin) { portfolio_coin.coin }

      context 'when buying' do
        let(:transaction) do
          create(:transaction,
                portfolio_coin: portfolio_coin,
                transaction_type: 'buy',
                quantity: 2.0,
                price: 45000.0)
        end

        it 'updates total_quantity after creation' do
          expect { transaction }.to change { portfolio_coin.reload.total_quantity }.from(0).to(2.0)
        end

        it 'updates average_buy_price after creation' do
          transaction
          expect(portfolio_coin.reload.average_buy_price).to eq(45000.0)
        end
      end

      context 'when selling' do
        let!(:buy_transaction) do
          create(:transaction,
                portfolio_coin: portfolio_coin,
                transaction_type: 'buy',
                quantity: 2.0,
                price: 40000.0)
        end

        let(:sell_transaction) do
          create(:transaction,
                portfolio_coin: portfolio_coin,
                transaction_type: 'sell',
                quantity: 1.0,
                price: 45000.0)
        end

        it 'updates total_quantity after creation' do
          expect { sell_transaction }.to change { portfolio_coin.reload.total_quantity }.from(2.0).to(1.0)
        end

        it 'does not change average_buy_price' do
          expect { sell_transaction }.not_to change { portfolio_coin.reload.average_buy_price }
        end

        context 'when selling more than available' do
          let(:invalid_sell) do
            build(:transaction,
                  portfolio_coin: portfolio_coin,
                  transaction_type: 'sell',
                  quantity: 3.0,
                  price: 45000.0)
          end

          it 'is invalid' do
            expect(invalid_sell).not_to be_valid
            expect(invalid_sell.errors[:quantity]).to include("exceeds available balance")
          end
        end
      end
    end
  end
end 