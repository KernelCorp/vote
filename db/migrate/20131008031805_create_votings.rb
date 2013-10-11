class CreateVotings < ActiveRecord::Migration
  def change
    create_table :votings do |t|
      t.string :name
      t.datetime :start_date
      t.references :organization

      t.timestamps
    end
  end
end
