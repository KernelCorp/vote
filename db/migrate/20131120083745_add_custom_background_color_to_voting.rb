class AddCustomBackgroundColorToVoting < ActiveRecord::Migration
  def change
    add_column :votings, :custom_background_color, :string
  end
end
