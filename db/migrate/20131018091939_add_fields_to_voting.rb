class AddFieldsToVoting < ActiveRecord::Migration
  def change
    #general
    add_column :votings, :description, :text
    add_column :votings, :way_to_complete, :string
    add_column :votings, :min_count_users, :integer
    add_column :votings, :end_date, :datetime

    add_attachment :votings, :prize
    add_attachment :votings, :brand

    #for monetary voting
    add_column :votings, :cost, :float
    add_column :votings, :min_sum, :float
    add_column :votings, :financial_threshold, :float
    add_column :votings, :budget, :float


  end
end
