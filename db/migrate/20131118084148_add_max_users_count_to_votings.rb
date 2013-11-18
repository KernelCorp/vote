class AddMaxUsersCountToVotings < ActiveRecord::Migration
  def change
    add_column :votings, :max_users_count, :integer
  end
end
