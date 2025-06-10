class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.integer      :transaction_type, limit: 1, index: true, null: false
      t.decimal      :quantity, precision: 30, scale: 10, null: false
      t.decimal      :price, precision: 30, scale: 10, null: false
      t.string       :note
      t.datetime     :transaction_date, null: false
      t.references   :portfolio_coin, index: true, foreign_key: true, null: false
      t.timestamps
    end
  end
end
