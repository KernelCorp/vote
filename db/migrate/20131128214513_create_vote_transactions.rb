class CreateVoteTransactions < ActiveRecord::Migration
  def change
    create_table :vote_transactions do |t|
      t.integer :amount
      t.references :claim
      t.references :participant

      t.timestamps
    end
  end
end
