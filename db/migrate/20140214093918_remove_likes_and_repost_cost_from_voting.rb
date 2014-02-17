class RemoveLikesAndRepostCostFromVoting < ActiveRecord::Migration
  def up
    remove_column :votings, :cost_of_like
    remove_column :votings, :cost_of_repost
  end

  def down
    add_column :votings, :cost_of_like, :integer
    add_column :votings, :cost_of_repost, :integer
  end
end
