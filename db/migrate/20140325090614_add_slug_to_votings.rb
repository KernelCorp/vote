class AddSlugToVotings < ActiveRecord::Migration
  def change
    add_column :votings, :slug, :string
    add_index :votings, :slug, unique: true
  end
end
