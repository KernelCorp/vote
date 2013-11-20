class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings, {id: false, force: true} do |t|
      t.string :key, primary_key: true
      t.string :type
      t.integer :int_value
      t.string :str_value

      t.timestamps
    end

  end
end
