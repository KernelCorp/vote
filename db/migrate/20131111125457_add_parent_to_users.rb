class AddParentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :parent_id, :integer
    add_column :users, :paid, :boolean, null: false, default: false
  end
end
