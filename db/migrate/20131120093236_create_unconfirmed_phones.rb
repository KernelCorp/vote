class CreateUnconfirmedPhones < ActiveRecord::Migration
  def change
    create_table :unconfirmed_phones do |t|
      t.string :number
      t.string :confirmation_code
      t.references :participant

      t.timestamps
    end
    add_index :unconfirmed_phones, :participant_id
  end
end
