class ChangeSocialVotersSocialIdType < ActiveRecord::Migration
  def up
    change_column :social_voters, :social_id, :string
  end

  def down
    change_column :social_voters, :social_id, :integer
  end
end
