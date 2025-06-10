class UpdateCoinsJob
  include Sidekiq::Job
  
  sidekiq_options queue: :default, retry: 3

  def perform
    Rails.logger.info "Starting UpdateCoinsJob at #{Time.current}"

    begin
      market_service = Coingecko::MarketService.new
      market_service.sync_markets(per_page: 200)
    rescue StandardError => e
      Rails.logger.error "Error in UpdateCoinsJob: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      raise e # Re-raise to trigger Sidekiq retry mechanism
    end
  end
end 