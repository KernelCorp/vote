class AddTypeToVotings < ActiveRecord::Migration
  def change
    add_column :votings, :type, :string, null: false, default: 'MonetaryVoting'
  end
end
