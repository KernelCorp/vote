class AddUniqueToNumberInPhone < ActiveRecord::Migration
  def up
    add_index :phones, :number, :unique => true
  end

  def down
    remove_index :phones, :number
  end
end
