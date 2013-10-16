class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.string :number
      t.references :participant

      t.timestamps
    end
    add_index :phones, :participant_id
  end
end
