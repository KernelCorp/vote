class AddFieldsToOrganisation < ActiveRecord::Migration
  def change
    add_column :users, :org_name, :string
    add_column :users, :site, :string
    add_column :users, :post_address, :string
    add_column :users, :jur_address, :string
    add_column :users, :rc, :string
    add_column :users, :kc, :string
    add_column :users, :bik, :string
    add_column :users, :inn, :string
    add_column :users, :kpp, :string
    add_column :users, :ceo, :string
  end
end
