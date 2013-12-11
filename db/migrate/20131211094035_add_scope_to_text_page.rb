class AddScopeToTextPage < ActiveRecord::Migration
  def change
    add_column :text_pages, :scope, :integer
  end
end
