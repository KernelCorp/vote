class AddEndTimerToVotings < ActiveRecord::Migration
  def change
    add_column :votings, :end_timer, :datetime
  end
end
