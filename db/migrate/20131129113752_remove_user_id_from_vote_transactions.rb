class RemoveUserIdFromVoteTransactions < ActiveRecord::Migration
  def up
    remove_column :vote_transactions, :user_id
  end

  def down
    add_column :vote_transactions, :user_id, :integer
  end
end
