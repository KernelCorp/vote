class CreateClaimStatistics < ActiveRecord::Migration
  def change
    create_table :claim_statistics do |t|
      t.references :claim
      t.integer :votes_count

      t.timestamps
    end
    add_index :claim_statistics, :claim_id
  end
end
