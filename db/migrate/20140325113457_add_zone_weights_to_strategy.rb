class AddZoneWeightsToStrategy < ActiveRecord::Migration
  def change
    add_column :strategies, :red, :float
    add_column :strategies, :yellow, :float
    add_column :strategies, :green, :float
  end
end
