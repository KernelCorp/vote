class AddPlaceToClaimStatistics < ActiveRecord::Migration
  def change
    add_column :claim_statistics, :place, :integer
  end
end
