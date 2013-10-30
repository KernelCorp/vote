class AddOrganizationIdToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :organization_id, :integer
  end
end
