# README

# DB Diagram: https://dbdiagram.io/d/Portfolio-649983b102bd1c4a5e131b7b
# Postman docs: https://documenter.getpostman.com/view/5693366/2sB2x5GXpc
# High level component: https://tinyurl.com/9v29cj5u

SYSTEM DESIGN
I/ Architecture Overview:
  1/ High Level Component:
    - Load Balancer (optional)
    - API Gateway (Optional)
    - API server
    - SQL DB
    - Redis
    - 3rd third party API from Coingecko

    * FYI => https://tinyurl.com/9v29cj5u

  2/ Techstack:
    Monolith Architecture
    + API server: Ruby on Rails (Ruby 3.1.4, Rails 7.1.3)
    + SQL Database: Posgresql
    + Auth: Devise Token Auth
    + Caching: Redis
    + Handling background job: Sidekiq
    + Client side: ReactJS

II/ Database:
    1/ users
    2/ coins
    3/ portfolios
    4/ portfolio_coins
    5/ transactions

    * FYI => https://dbdiagram.io/d/Portfolio-649983b102bd1c4a5e131b7b

III/ API design:
    1/ Controller:
        - Auth Controller
        - CoinsController
        - PortfoliosController
        - PortfolioCoinsController
        - TransactionsController
    2/ Model:
        - User, Coin, Portfolio, PortfolioCoin, Transaction

    3/ API url
        - Auth API
        - Coin API
        - Portfolio API:
            + Portfolio Coin API
            + Transaction API

    * FYI => https://documenter.getpostman.com/view/5693366/2sB2x5GXpc
