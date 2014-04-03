class ChangeSocialVoters < ActiveRecord::Migration
  def change
    add_column :social_voters, :liked, :boolean
    add_index :social_voters, :reposted
    add_index :social_voters, :liked
  end
end
