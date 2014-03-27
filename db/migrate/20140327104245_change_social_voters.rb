class ChangeSocialVoters < ActiveRecord::Migration
  def change
    change_table :social_voters do |t|
      t.boolean :liked

      t.index :reposted
      t.index :liked
    end
  end
end
