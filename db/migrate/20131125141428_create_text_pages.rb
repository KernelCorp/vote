class CreateTextPages < ActiveRecord::Migration
  def change
    create_table :text_pages do |t|
      t.string :name
      t.text :source
      t.string :slug

      t.timestamps
    end

    add_index :text_pages, :slug, unique: true
  end
end
