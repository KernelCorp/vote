class AddRegistedAtToVoters < ActiveRecord::Migration
  def change
    add_column :social_voters, :registed_at, :string
  end
end
