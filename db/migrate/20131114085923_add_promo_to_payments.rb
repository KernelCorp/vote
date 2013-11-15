class AddPromoToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :promo, :string
  end
end
