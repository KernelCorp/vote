class AddStatusToVoting < ActiveRecord::Migration
  def change
    add_column :votings, :status, :integer, null: false, default: 0
  end
end
