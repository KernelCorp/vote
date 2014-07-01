class RenameArgsCrtiterionToGroupId < ActiveRecord::Migration
  def change
    rename_column :strategy_criterions, :args, :group_id
  end
end
