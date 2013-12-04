class CreateStrangers < ActiveRecord::Migration
  def change
    create_table :strangers do |t|
      t.string :phone
      t.string :email
      t.string :firstname
      t.string :secondname
      t.string :fathersname

      t.timestamps
    end
  end
end
