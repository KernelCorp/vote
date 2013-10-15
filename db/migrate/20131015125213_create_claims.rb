class CreateClaims < ActiveRecord::Migration
  def change
    create_table :claims do |t|
      t.references :participant
      t.references :voting
      t.string :phone
      t.timestamps
    end
    add_index :claims, :participant_id
    add_index :claims, :voting_id
  end
end
