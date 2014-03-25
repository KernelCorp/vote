class CreateSocialStatesAndVoters < ActiveRecord::Migration
  def change
    create_table :social_states do |t|
      t.references :post
      t.integer    :likes
      t.integer    :reposts
      t.timestamps
    end

    add_index :social_states, :post_id


    create_table :social_voters do |t|
      t.references :state
      t.string     :url
      t.boolean    :reposted
      t.string     :relationship
      t.boolean    :has_avatar
      t.boolean    :too_friendly
    end

    add_index :social_voters, :state_id
  end
end
