class AddOneTimePasswordToUsers < ActiveRecord::Migration
  def change
    add_column :users, :one_time_password, :string
  end
end
