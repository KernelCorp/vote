class ChangeZonesNames < ActiveRecord::Migration
  def change
    rename_column :strategies, :friends_zone,    :friend_zone
    rename_column :strategies, :subscriber_zone, :follower_zone
    rename_column :strategies, :unknown_zone,    :guest_zone
  end
end
