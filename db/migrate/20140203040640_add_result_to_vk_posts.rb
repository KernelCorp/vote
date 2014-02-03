class AddResultToVkPosts < ActiveRecord::Migration
  def change
    add_column :vk_posts, :result, :integer
  end
end
