class ChangeFrequency < ActiveRecord::Migration
  def up
    change_column :votings, :snapshot_frequency, :integer, default: 2, null: false
  end

  def down
    change_column :votings, :snapshot_frequency, :integer, default: 2
  end
end
