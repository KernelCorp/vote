class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :users
      t.timestamps
    end
  end
end
