class AddFieldsToVotings < ActiveRecord::Migration
  def change
    add_column :votings, :cost_of_like, :integer
    add_column :votings, :cost_of_repost, :integer
  end
end
