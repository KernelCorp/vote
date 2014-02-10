class AddUrlToVkPosts < ActiveRecord::Migration
  def change
    add_column :vk_posts, :url, :string
  end
end
