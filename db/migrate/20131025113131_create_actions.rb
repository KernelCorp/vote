class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.string :name
      t.references :voting
      t.integer :points

      t.timestamps
    end
    add_index :actions, :voting_id
  end
end
