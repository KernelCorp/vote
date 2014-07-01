class AddSocialIdToVoters < ActiveRecord::Migration
  def change
    add_column :social_voters, :social_id, :integer
  end
end
