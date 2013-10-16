class ChangePhoneAtUsersToUnique < ActiveRecord::Migration
  def up
    add_index :users, :phone, :unique => true
  end

  def down
    remove_index :users, :phone
  end
end
