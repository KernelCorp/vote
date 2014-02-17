class StartSocialPosts < ActiveRecord::Migration
  def change
    rename_table :vk_posts, :social_posts
    rename_column :social_posts, :result, :points
    add_column :social_posts, :type, :string


    rename_table :actions, :other_actions

    create_table :social_actions do |t|
      t.string      :type
      t.references  :voting
      t.integer     :like_points
      t.integer     :repost_points
    end
    add_index :social_actions, [:voting_id, :type], :unique
  end
end
