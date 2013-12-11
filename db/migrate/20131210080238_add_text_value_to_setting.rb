class AddTextValueToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :text_value, :text
  end
end
