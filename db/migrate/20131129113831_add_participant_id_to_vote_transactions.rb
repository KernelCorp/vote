class AddParticipantIdToVoteTransactions < ActiveRecord::Migration
  def change
    add_column :vote_transactions, :participant_id, :integer
  end
end
