class CreateCriterions < ActiveRecord::Migration
  def change
    create_table :strategy_criterions do |t|
      t.integer :priority, default: 0, null: false
      t.integer :zone

      t.string :type

      t.references :strategy
    end

    add_index :strategy_criterions, :strategy_id

    remove_column :strategies, :friend_zone
    remove_column :strategies, :follower_zone
    remove_column :strategies, :guest_zone
    remove_column :strategies, :no_avatar_zone
    remove_column :strategies, :too_friendly_zone
  end
end
