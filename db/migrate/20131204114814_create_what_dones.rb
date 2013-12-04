class CreateWhatDones < ActiveRecord::Migration
  def change
    create_table :what_dones do |t|
      t.references :who
      t.references :voting
      t.references :what

      t.timestamps
    end
    add_index :what_dones, :who_id
    add_index :what_dones, :voting_id
    add_index :what_dones, :what_id
  end
end
