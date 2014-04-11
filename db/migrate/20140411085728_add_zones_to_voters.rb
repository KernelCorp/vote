class AddZonesToVoters < ActiveRecord::Migration
  def change
    add_column :social_voters, :zone, :integer
  end
end
