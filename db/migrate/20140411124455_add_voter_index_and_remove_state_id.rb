class AddVoterIndexAndRemoveStateId < ActiveRecord::Migration
  def change
    remove_column :social_voters, :state_id
    add_index :social_voters, [:post_id, :url], unique: true
  end
end
