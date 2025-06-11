require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe UpdateCoinsJob, type: :job do
  before(:each) do
    Sidekiq::Testing.fake!
  end

  after(:each) do
    Sidekiq::Worker.clear_all
  end

  describe '#perform' do
    let!(:bitcoin) { create(:coin, :bitcoin) }
    let!(:ethereum) { create(:coin, :ethereum) }
    let(:market_service) { instance_double(Coingecko::MarketService) }

    before do
      allow(Coingecko::MarketService).to receive(:new).and_return(market_service)
      allow(market_service).to receive(:sync_markets)
    end

    it 'updates coin prices' do
      expect {
        described_class.perform_async
      }.to change(described_class.jobs, :size).by(1)

      described_class.drain
      expect(market_service).to have_received(:sync_markets)
    end

    context 'when API request fails' do
      before do
        allow(market_service).to receive(:sync_markets)
          .and_raise(Coingecko::BaseService::ApiError.new('API error'))
      end

      it 'retries the job' do
        expect {
          described_class.perform_async
          described_class.drain
        }.to raise_error(Coingecko::BaseService::ApiError)
      end
    end
  end
end 
