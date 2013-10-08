class CreateAtomVotes < ActiveRecord::Migration
  def change
    create_table :atom_votes do |t|
      t.int :vote_count
      t.int :number
      t.referense :position

      t.timestamps
    end
  end
end
