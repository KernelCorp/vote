class SetDefaultsForStrategy < ActiveRecord::Migration
  def self.up
    change_column :strategies, :red, :float, default: 0.1
    change_column :strategies, :yellow, :float, default: 1
    change_column :strategies, :green, :float, default: 1
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration, "Can't remove the default"
  end
end
