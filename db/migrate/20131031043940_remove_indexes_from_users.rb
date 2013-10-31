class RemoveIndexesFromUsers < ActiveRecord::Migration
  remove_index :users, :email
  remove_index :users, :login
end
