class CreateVoteTransactions < ActiveRecord::Migration
  def change
    create_table :vote_transactions do |t|
      t.integer :amount
      t.references :claim
      t.references :user

      t.timestamps
    end
  end
end
