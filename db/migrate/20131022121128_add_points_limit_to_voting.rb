class AddPointsLimitToVoting < ActiveRecord::Migration
  def change
    add_column :votings, :points_limit, :integer
  end
end
