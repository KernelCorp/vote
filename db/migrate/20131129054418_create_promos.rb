class CreatePromos < ActiveRecord::Migration
  def change
    create_table :promos do |t|
      t.string :code
      t.datetime :date_end
      t.integer :amount, null: false, default: 0

      t.timestamps
    end
  end
end
