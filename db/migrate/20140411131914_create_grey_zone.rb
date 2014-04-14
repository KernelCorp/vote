class CreateGreyZone < ActiveRecord::Migration
  def change
    add_column :strategies, :grey, :float, default: 1.0, null: false
  end
end
