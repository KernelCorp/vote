class AddBackgroundToVoting < ActiveRecord::Migration
  def change
    add_attachment :votings, :custom_background
  end
end
