class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name
      t.decimal :price
      t.integer :quantity

      t.timestamps
    end

    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total_price
      t.string :status
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
