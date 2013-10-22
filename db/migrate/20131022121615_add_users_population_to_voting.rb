class AddUsersPopulationToVoting < ActiveRecord::Migration
  def change
    add_column :votings, :users_population, :integer
  end
end
