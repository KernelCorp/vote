class CreateAtomVotes < ActiveRecord::Migration
  def change
    create_table :atom_votes do |t|
      t.integer :votes_count
      t.integer :number, :length => 1
      t.references :position

      t.timestamps
    end
  end
end
