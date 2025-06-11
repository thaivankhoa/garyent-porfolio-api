require 'rails_helper'

RSpec.describe 'Portfolio Management', type: :request do
  let(:user) { create(:user) }
  let(:headers) { user.create_new_auth_token }
  let(:bitcoin) { create(:coin, :bitcoin) }
  let(:ethereum) { create(:coin, :ethereum) }
  let(:market_service) { instance_double(Coingecko::MarketService) }

  before do
    bitcoin
    ethereum
    allow(Coingecko::MarketService).to receive(:new).and_return(market_service)
    allow(market_service).to receive(:sync_markets).and_return([
      {
        'id' => 'bitcoin',
        'symbol' => 'btc',
        'name' => 'Bitcoin',
        'current_price' => 105000.0,
        'market_cap' => 850000000000,
        'market_cap_rank' => 1,
        'total_volume' => 28000000000,
        'price_change_percentage_24h' => 2.5,
        'last_updated' => Time.current
      },
      {
        'id' => 'ethereum',
        'symbol' => 'eth',
        'name' => 'Ethereum',
        'current_price' => 2500.0,
        'market_cap' => 240000000000,
        'market_cap_rank' => 2,
        'total_volume' => 15000000000,
        'price_change_percentage_24h' => 1.8,
        'last_updated' => Time.current
      }
    ])
  end

  it 'allows user to manage their portfolio' do
    # Create a portfolio
    portfolio = create(:portfolio, user: user)

    # Add Bitcoin to portfolio
    btc_portfolio_coin = create(:portfolio_coin, portfolio: portfolio, coin: bitcoin)

    # Add a buy transaction for Bitcoin
    post "/api/v1/portfolio_coins/#{btc_portfolio_coin.id}/transactions", params: {
      transaction: {
        transaction_type: 'buy',
        quantity: 1.5,
        price: 40000.0,
        transaction_date: Time.current
      }
    }, headers: headers

    expect(response).to have_http_status(:created)
    expect(json_response['data']['attributes']['transaction_type']).to eq('buy')
    expect(json_response['data']['attributes']['quantity'].to_f).to eq(1.5)

    # Add Ethereum to portfolio
    eth_portfolio_coin = create(:portfolio_coin, portfolio: portfolio, coin: ethereum)

    # Add a buy transaction for Ethereum
    post "/api/v1/portfolio_coins/#{eth_portfolio_coin.id}/transactions", params: {
      transaction: {
        transaction_type: 'buy',
        quantity: 10.0,
        price: 1800.0,
        transaction_date: Time.current
      }
    }, headers: headers

    expect(response).to have_http_status(:created)

    # Get portfolio details
    get "/api/v1/portfolios/#{portfolio.id}", headers: headers
    expect(response).to have_http_status(:ok)
    
    portfolio_data = json_response['data']
    expect(portfolio_data['attributes']['total_value']).to eq(182500.0) # (1.5 * 105000) + (10 * 2500)
    expect(portfolio_data['attributes']['total_profit_loss']).to eq(104500.0) # (1.5 * (105000 - 40000)) + (10 * (2500 - 1800))
    
    # Add a sell transaction for Bitcoin
    post "/api/v1/portfolio_coins/#{btc_portfolio_coin.id}/transactions", params: {
      transaction: {
        transaction_type: 'sell',
        quantity: 0.5,
        price: 105000.0,
        transaction_date: Time.current
      }
    }, headers: headers

    expect(response).to have_http_status(:created)

    # Verify portfolio coin quantities
    get "/api/v1/portfolios/#{portfolio.id}", headers: headers
    portfolio_coins = json_response['data']['relationships']['portfolio_coins']['data']
    
    btc_coin = portfolio_coins.find { |pc| pc['relationships']['coin']['data']['id'].to_i == bitcoin.id }
    eth_coin = portfolio_coins.find { |pc| pc['relationships']['coin']['data']['id'].to_i == ethereum.id }
    
    expect(btc_coin['attributes']['quantity']).to eq(1.0) # 1.5 - 0.5
    expect(eth_coin['attributes']['quantity']).to eq(10.0)
  end
end 