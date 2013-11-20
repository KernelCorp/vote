class DefaultValueForeSomeVotingsField < ActiveRecord::Migration
  def change
    change_column :votings, :cost,             :float,   null: false, default: 0
    change_column :votings, :min_sum,          :float,   null: false, default: 0
    change_column :votings, :budget,           :float,   null: false, default: 0
    change_column :votings, :timer,            :integer, null: false, default: 0
    change_column :votings, :cost_10_points,   :float,   null: false, default: 0
    change_column :votings, :users_population, :integer, null: false, default: 0
    change_column :votings, :points_limit,     :integer, null: false, default: 0
    change_column :votings, :min_count_users,  :integer, null: false, default: 0
  end

end
