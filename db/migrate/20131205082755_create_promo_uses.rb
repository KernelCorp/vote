class CreatePromoUses < ActiveRecord::Migration
  def change
    create_table :promo_uses do |t|
      t.references :participant
      t.references :promo

      t.timestamps
    end
    add_index :promo_uses, :participant_id
    add_index :promo_uses, :promo_id
  end
end
