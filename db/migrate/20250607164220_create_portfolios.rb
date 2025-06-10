class CreatePortfolios < ActiveRecord::Migration[7.1]
  def change
    create_table :portfolios do |t|
      t.string       :name
      t.references   :user, index: true, foreign_key: true, null: false
      t.timestamps
    end
  end
end
