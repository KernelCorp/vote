class AddWithPromoToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :with_promo, :boolean
  end
end
