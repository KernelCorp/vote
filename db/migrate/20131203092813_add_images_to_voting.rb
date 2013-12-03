class AddImagesToVoting < ActiveRecord::Migration
  def self.up
    change_table :votings do |t|
      t.attachment :prize1
      t.attachment :prize2
      t.attachment :prize3
    end
  end

  def self.down
    drop_attached_file :votings, :prize1
    drop_attached_file :votings, :prize2
    drop_attached_file :votings, :prize3
  end
end