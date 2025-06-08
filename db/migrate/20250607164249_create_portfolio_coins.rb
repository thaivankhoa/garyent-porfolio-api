class CreatePortfolioCoins < ActiveRecord::Migration[7.1]
  def change
    create_table :portfolio_coins do |t|
      t.references     :coin, index: true, foreign_key: true, null: false
      t.references     :portfolio, index: true, foreign_key: true, null: false
      t.timestamps
    end
  end
end
