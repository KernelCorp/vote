class AddGenderBdateCityToVoters < ActiveRecord::Migration
  def change
    add_column :social_voters, :gender, :integer
    add_column :social_voters, :bdate, :datetime
    add_column :social_voters, :city, :string
  end
end
