class CreateSocialProfile < ActiveRecord::Migration
  def change
    create_table :social_profiles do |t|
      t.references :participant

      t.string :provider
      t.string :uid
    end
    add_index :social_profiles, :participant_id
  end
end
