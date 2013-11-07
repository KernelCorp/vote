class AddIsConfirmedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_confirmed, :boolean, null: false, default: false
  end
end
