class AddCost10PointsToVoting < ActiveRecord::Migration
  def change
    add_column :votings, :cost_10_points, :integer
  end
end
