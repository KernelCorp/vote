class ChangeZonesNames < ActiveRecord::Migration
  def change
    change_table :strategies do |t|
      t.rename :friends_zone, :friend_zone
      t.rename :subscriber_zone, :follower_zone
      t.rename :unknown_zone, :guest_zone
    end
  end
end
