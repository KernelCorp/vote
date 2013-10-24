class AddIsApprovedToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :is_approved, :boolean , null: false, default: false
  end
end
