class SetDefaultSnapshotFrequencyAsHourly < ActiveRecord::Migration
  def up
    change_column_default :votings, :snapshot_frequency, 2
  end

  def down
    change_column_default :votings, :snapshot_frequency, nil
  end
end
