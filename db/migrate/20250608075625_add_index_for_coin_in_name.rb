class AddIndexForCoinInName < ActiveRecord::Migration[7.1]
  def change
    add_index :coins, :name
  end
end
