class AddCustomHeadColorToVotings < ActiveRecord::Migration
  def change
    add_column :votings, :custom_head_color, :string
  end
end
