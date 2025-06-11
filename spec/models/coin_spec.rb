require 'rails_helper'

RSpec.describe Coin, type: :model do
  describe 'associations' do
    it { should have_many(:portfolio_coins) }
    it { should have_many(:portfolios).through(:portfolio_coins) }
  end

  describe 'validations' do
    subject { build(:coin) }

    it { should validate_presence_of(:coingecko_id) }
    it { should validate_uniqueness_of(:coingecko_id) }
    it { should validate_presence_of(:symbol) }
    it { should validate_presence_of(:name) }
  end
end 