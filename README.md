# Crypto Portfolio API

## Documentation & Diagrams
- [Database Diagram](https://dbdiagram.io/d/Portfolio-649983b102bd1c4a5e131b7b)
- [API Documentation](https://documenter.getpostman.com/view/5693366/2sB2x5GXpc)
- [System Architecture](https://tinyurl.com/9v29cj5u)

## System Design

### I. Architecture Overview

#### 1. High Level Components
- Load Balancer (optional)
- API Gateway (Optional)
- API Server
- SQL Database
- Redis
- 3rd Party API (Coingecko)

[View Architecture Diagram](https://tinyurl.com/9v29cj5u)

#### 2. Tech Stack
**Monolith Architecture**
- API Server: Ruby on Rails (Ruby 3.1.4, Rails 7.1.3)
- Database: PostgreSQL
- Authentication: Devise Token Auth
- Caching: Redis
- Background Jobs: Sidekiq
- Frontend: ReactJS

### II. Database Structure
1. Users
2. Coins
3. Portfolios
4. Portfolio Coins
5. Transactions

[View Database Diagram](https://dbdiagram.io/d/Portfolio-649983b102bd1c4a5e131b7b)

### III. API Design

#### 1. Controllers
- Auth Controller
- Coins Controller
- Portfolios Controller
- Portfolio Coins Controller
- Transactions Controller

#### 2. Models
- User
- Coin
- Portfolio
- PortfolioCoin
- Transaction

#### 3. API Endpoints
- Authentication API
- Coin API
- Portfolio API
  - Portfolio Coin API
  - Transaction API

[View Full API Documentation](https://documenter.getpostman.com/view/5693366/2sB2x5GXpc)
