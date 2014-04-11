class CreateStatesVotersJoinTable < ActiveRecord::Migration
  def change
    add_column :social_voters, :post_id, :integer

    create_table :states_voters, id: false do |t|
      t.references :state
      t.references :voter
    end

    add_index :states_voters, [:state_id, :voter_id], unique: true
  end
end
