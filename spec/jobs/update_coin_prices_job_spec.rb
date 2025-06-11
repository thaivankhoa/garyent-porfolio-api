# require 'rails_helper'

# RSpec.describe UpdateCoinsJob, type: :job do
#   include ActiveJob::TestHelper

#   describe '#perform' do
#     let!(:bitcoin) { create(:coin, :bitcoin) }
#     let!(:ethereum) { create(:coin, :ethereum) }

#     context 'when API request is successful' do
#       before do
#         allow(Coin).to receive(:update_prices)
#       end

#       it 'updates coin prices' do
#         perform_enqueued_jobs { described_class.perform_later }
#         expect(Coin).to have_received(:update_prices)
#       end
#     end

#     context 'when API request fails' do
#       before do
#         allow(Coin).to receive(:update_prices)
#           .and_raise(Coingecko::BaseService::ApiError.new('API error'))
#       end

#       it 'retries the job' do
#         expect {
#           perform_enqueued_jobs { described_class.perform_later }
#         }.to raise_error(Coingecko::BaseService::ApiError)
#       end
#     end
#   end
# end 