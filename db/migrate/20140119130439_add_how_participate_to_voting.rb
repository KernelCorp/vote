class AddHowParticipateToVoting < ActiveRecord::Migration
  def change
    add_column :votings, :how_participate, :text
  end
end
