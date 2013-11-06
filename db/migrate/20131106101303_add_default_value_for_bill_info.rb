class AddDefaultValueForBillInfo < ActiveRecord::Migration
  def up
    change_column :users, :billinfo, :integer, null: false, default: 0
  end

  def down
    change_column :users, :billinfo, :integer, null: false, default: nil
  end
end
