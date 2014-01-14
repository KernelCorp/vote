class CreateVkPosts < ActiveRecord::Migration
  def change
    create_table :vk_posts do |t|
      t.references :participant
      t.references :voting
      t.string :post_id

      t.timestamps
    end
    add_index :vk_posts, :participant_id
    add_index :vk_posts, :voting_id
  end
end
