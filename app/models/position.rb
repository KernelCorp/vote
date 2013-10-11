class Position < ActiveRecord::Base
  belongs_to :phone
  has_many :votes, :class_name => AtomVote, :before_add => :validate_votes

  def initialize
    0.upto 9 do |i|
      votes.build(:number => i, :votes_count => 0)
    end
  end

  def lead_number_with_votes_count
    votes.order('`atom_votes`.`votes_count`').last
  end

  private

  def validate_votes (vote)
    if votes.where(:number => vote.number).empty?
      true
    else
      raise ArgumentError.new("You mess things up, bastard.")
    end
  end
end
