require 'rails_helper'

RSpec.describe UpdateCoinsJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform' do
    let!(:bitcoin) { create(:coin, :bitcoin) }
    let!(:ethereum) { create(:coin, :ethereum) }
    let(:market_service) { instance_double(Coingecko::MarketService) }

    before do
      allow(Coingecko::MarketService).to receive(:new).and_return(market_service)
      allow(market_service).to receive(:sync_markets)
    end

    it 'updates coin prices' do
      perform_enqueued_jobs { described_class.perform_later }
      expect(market_service).to have_received(:sync_markets)
    end

    context 'when API request fails' do
      before do
        allow(market_service).to receive(:sync_markets)
          .and_raise(Coingecko::BaseService::ApiError.new('API error'))
      end

      it 'retries the job' do
        expect {
          perform_enqueued_jobs { described_class.perform_later }
        }.to raise_error(Coingecko::BaseService::ApiError)
      end
    end
  end
end 