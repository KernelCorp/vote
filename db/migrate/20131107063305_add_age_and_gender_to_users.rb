class AddAgeAndGenderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :age, :integer
    add_column :users, :gender, :boolean
    add_column :users, :city, :string
  end
end
