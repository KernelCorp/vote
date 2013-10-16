class ChangePhoneAtUsersToUnique < ActiveRecord::Migration
  def up
    change_column :users, :phone, unique: true
  end

  def down
    change_column :users, :phone, unique: false
  end
end
