class AddSnapshotFrequencyToVotings < ActiveRecord::Migration
  def change
    add_column :votings, :snapshot_frequency, :integer
    add_index :votings, :snapshot_frequency
  end
end
