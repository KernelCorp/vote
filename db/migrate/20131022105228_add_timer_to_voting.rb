class AddTimerToVoting < ActiveRecord::Migration
  def change
    add_column :votings, :timer, :text
  end
end
