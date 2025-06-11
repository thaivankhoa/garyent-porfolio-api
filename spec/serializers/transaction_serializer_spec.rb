# require 'rails_helper'

# RSpec.describe TransactionSerializer do
#   let(:transaction) do
#     create(:transaction,
#            transaction_type: 'buy',
#            quantity: 1.5,
#            price: 45000.0,
#            executed_at: Time.current)
#   end

#   subject { described_class.new(transaction).as_json }

#   it 'includes transaction attributes' do
#     expect(subject[:data][:attributes]).to include(
#       transaction_type: 'buy',
#       quantity: 1.5,
#       price: 45000.0,
#       total_amount: 67500.0, # 1.5 * 45000
#       executed_at: transaction.executed_at.as_json
#     )
#   end

#   it 'includes portfolio_coin relationship' do
#     expect(subject[:data][:relationships]).to include(:portfolio_coin)
#     expect(subject[:data][:relationships][:portfolio_coin][:data][:id].to_i).to eq(transaction.portfolio_coin_id)
#   end
# end 