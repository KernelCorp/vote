class RemoveVotesCountFromClaimStatistics < ActiveRecord::Migration
  def up
    remove_column :claim_statistics, :votes_count
  end

  def down
    add_column :claim_statistics, :votes_count, :integer
  end
end
