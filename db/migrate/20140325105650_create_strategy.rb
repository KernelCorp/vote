class CreateStrategy < ActiveRecord::Migration
  def change
    create_table :strategies do |t|
      t.references :voting
      t.integer    :no_avatar_zone,    default: 1
      t.integer    :friends_zone,      default: 0
      t.integer    :unknown_zone,      default: 2
      t.integer    :subscriber_zone,   default: 1
      t.integer    :too_friendly_zone, default: 1
    end
    add_index :strategies, :voting_id
  end
end
