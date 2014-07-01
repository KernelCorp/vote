class AddArgsToCriterions < ActiveRecord::Migration
  def change
    add_column :strategy_criterions, :args, :string
  end
end
