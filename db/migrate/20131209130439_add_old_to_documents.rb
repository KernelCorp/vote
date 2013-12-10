class AddOldToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :old, :boolean, default: false
  end
end
