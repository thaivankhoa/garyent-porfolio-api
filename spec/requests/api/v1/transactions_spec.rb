require 'rails_helper'

RSpec.describe 'API V1 Transactions', type: :request do
  let(:user) { create(:user) }
  let(:headers) { user.create_new_auth_token }
  let(:portfolio) { create(:portfolio, user: user) }
  let(:portfolio_coin) { create(:portfolio_coin, portfolio: portfolio) }

  describe 'GET /api/v1/portfolio_coins/:portfolio_coin_id/transactions' do
    let!(:transaction1) { create(:transaction, portfolio_coin: portfolio_coin) }
    let!(:transaction2) { create(:transaction, portfolio_coin: portfolio_coin) }
    let!(:other_transaction) { create(:transaction) }

    context 'when portfolio coin belongs to user' do
      before { get "/api/v1/portfolio_coins/#{portfolio_coin.id}/transactions", headers: headers }

      it 'returns portfolio coin transactions' do
        expect(response).to have_http_status(:ok)
        expect(json_response['data'].length).to eq(2)
        expect(json_response['data'].map { |t| t['id'].to_i }).to match_array([transaction1.id, transaction2.id])
      end
    end

    context 'when portfolio coin does not belong to user' do
      let(:other_portfolio_coin) { create(:portfolio_coin) }

      before { get "/api/v1/portfolio_coins/#{other_portfolio_coin.id}/transactions", headers: headers }

      it 'returns not found' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /api/v1/portfolio_coins/:portfolio_coin_id/transactions' do
    let(:valid_params) do
      {
        transaction: {
          transaction_type: 'buy',
          quantity: 1.5,
          price: 45000.0,
          transaction_date: Time.current
        }
      }
    end

    context 'when portfolio coin belongs to user' do
      context 'with valid params' do
        it 'creates a new transaction' do
          expect {
            post "/api/v1/portfolio_coins/#{portfolio_coin.id}/transactions",
                 params: valid_params,
                 headers: headers
          }.to change(Transaction, :count).by(1)

          expect(response).to have_http_status(:created)
          expect(json_response['data']['attributes']['transaction_type']).to eq('buy')
          expect(json_response['data']['attributes']['quantity'].to_f).to eq(1.5)
        end

        it 'updates portfolio coin quantity and average buy price' do
          post "/api/v1/portfolio_coins/#{portfolio_coin.id}/transactions",
               params: valid_params,
               headers: headers

          portfolio_coin.reload
          expect(portfolio_coin.quantity).to eq(1.5)
          expect(portfolio_coin.average_buy_price).to eq(45000.0)
        end
      end

      context 'with invalid params' do
        let(:invalid_params) do
          {
            transaction: {
              transaction_type: 'invalid',
              quantity: -1,
              price: 0
            }
          }
        end

        it 'returns validation errors' do
          post "/api/v1/portfolio_coins/#{portfolio_coin.id}/transactions",
               params: invalid_params,
               headers: headers

          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_response['errors']).to include(
            hash_including('source' => { 'pointer' => '/data/attributes/transaction_type' }),
            hash_including('source' => { 'pointer' => '/data/attributes/quantity' }),
            hash_including('source' => { 'pointer' => '/data/attributes/price' })
          )
        end
      end

      context 'when selling more than available' do
        let(:sell_params) do
          {
            transaction: {
              transaction_type: 'sell',
              quantity: 2.0,
              price: 45000.0,
              transaction_date: Time.current
            }
          }
        end

        before { portfolio_coin.update!(quantity: 1.0) }

        it 'returns validation error' do
          post "/api/v1/portfolio_coins/#{portfolio_coin.id}/transactions",
               params: sell_params,
               headers: headers

          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_response['errors']).to include(
            hash_including('source' => { 'pointer' => '/data/attributes/quantity' })
          )
        end
      end
    end

    context 'when portfolio coin does not belong to user' do
      let(:other_portfolio_coin) { create(:portfolio_coin) }

      it 'returns not found' do
        post "/api/v1/portfolio_coins/#{other_portfolio_coin.id}/transactions",
             params: valid_params,
             headers: headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end 