# require 'rails_helper'

# RSpec.describe 'API V1 Portfolios', type: :request do
#   let(:user) { create(:user) }
#   let(:headers) { user.create_new_auth_token }

#   describe 'GET /api/v1/portfolios' do
#     let!(:portfolio1) { create(:portfolio, user: user) }
#     let!(:portfolio2) { create(:portfolio, user: user) }
#     let!(:other_user_portfolio) { create(:portfolio) }

#     before { get '/api/v1/portfolios', headers: headers }

#     it 'returns user portfolios' do
#       expect(response).to have_http_status(:ok)
#       expect(json_response['data'].length).to eq(2)
#       expect(json_response['data'].map { |p| p['id'].to_i }).to match_array([portfolio1.id, portfolio2.id])
#     end
#   end

#   describe 'GET /api/v1/portfolios/:id' do
#     let(:portfolio) { create(:portfolio, user: user) }
#     let!(:portfolio_coin1) { create(:portfolio_coin, portfolio: portfolio) }
#     let!(:portfolio_coin2) { create(:portfolio_coin, portfolio: portfolio) }

#     context 'when portfolio belongs to user' do
#       before { get "/api/v1/portfolios/#{portfolio.id}", headers: headers }

#       it 'returns the portfolio with coins' do
#         expect(response).to have_http_status(:ok)
#         expect(json_response['data']['id'].to_i).to eq(portfolio.id)
#         expect(json_response['data']['relationships']['portfolio_coins']['data'].length).to eq(2)
#       end
#     end

#     context 'when portfolio does not belong to user' do
#       let(:other_portfolio) { create(:portfolio) }

#       before { get "/api/v1/portfolios/#{other_portfolio.id}", headers: headers }

#       it 'returns not found' do
#         expect(response).to have_http_status(:not_found)
#       end
#     end
#   end

#   describe 'POST /api/v1/portfolios' do
#     let(:valid_params) do
#       {
#         portfolio: {
#           name: 'My Portfolio',
#         }
#       }
#     end

#     context 'with valid params' do
#       it 'creates a new portfolio' do
#         expect {
#           post '/api/v1/portfolios', params: valid_params, headers: headers
#         }.to change(Portfolio, :count).by(1)

#         expect(response).to have_http_status(:created)
#         expect(json_response['data']['attributes']['name']).to eq('My Portfolio')
#       end
#     end

#     context 'with invalid params' do
#       let(:invalid_params) { { portfolio: { name: '' } } }

#       it 'returns validation errors' do
#         post '/api/v1/portfolios', params: invalid_params, headers: headers

#         expect(response).to have_http_status(:unprocessable_entity)
#         expect(json_response['errors']).to include(hash_including('source' => { 'pointer' => '/data/attributes/name' }))
#       end
#     end
#   end

#   describe 'PATCH /api/v1/portfolios/:id' do
#     let(:portfolio) { create(:portfolio, user: user) }
#     let(:valid_params) do
#       {
#         portfolio: {
#           name: 'Updated Portfolio',
#         }
#       }
#     end

#     context 'when portfolio belongs to user' do
#       it 'updates the portfolio' do
#         patch "/api/v1/portfolios/#{portfolio.id}", params: valid_params, headers: headers

#         expect(response).to have_http_status(:ok)
#         expect(json_response['data']['attributes']['name']).to eq('Updated Portfolio')
#         expect(portfolio.reload.name).to eq('Updated Portfolio')
#       end
#     end

#     context 'when portfolio does not belong to user' do
#       let(:other_portfolio) { create(:portfolio) }

#       it 'returns not found' do
#         patch "/api/v1/portfolios/#{other_portfolio.id}", params: valid_params, headers: headers

#         expect(response).to have_http_status(:not_found)
#       end
#     end
#   end

#   describe 'DELETE /api/v1/portfolios/:id' do
#     let!(:portfolio) { create(:portfolio, user: user) }

#     context 'when portfolio belongs to user' do
#       it 'deletes the portfolio' do
#         expect {
#           delete "/api/v1/portfolios/#{portfolio.id}", headers: headers
#         }.to change(Portfolio, :count).by(-1)

#         expect(response).to have_http_status(:no_content)
#       end
#     end

#     context 'when portfolio does not belong to user' do
#       let(:other_portfolio) { create(:portfolio) }

#       it 'returns not found' do
#         delete "/api/v1/portfolios/#{other_portfolio.id}", headers: headers

#         expect(response).to have_http_status(:not_found)
#       end
#     end
#   end
# end 