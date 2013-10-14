class AddIndexToAtomVotes < ActiveRecord::Migration
  def change
    add_index :atom_votes, [:position_id, :number], :unique => true
    add_index :atom_votes, :votes_count
  end
end
