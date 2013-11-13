class Position < ActiveRecord::Base
  belongs_to :phone
  has_many :votes,
    :class_name => AtomVote,
    :before_add => :validate_votes,
    :dependent => :destroy

  def sorted_up_votes
    votes.order('`atom_votes`.`votes_count` ASC')
  end

  def sorted_down_votes
    votes.order('`atom_votes`.`votes_count` DESC')
  end

  after_create :fullup_votes
  after_save :save_for_future

  def popularity
    popularity = 0
    votes.each { |v| popularity += v.votes_count }
    popularity
  end

  def length_to_first_place_for_number (number)
    votes.find_by_number(number).length_to_first
  end

  def length_to_next_place_for_number (number)
    votes.find_by_number(number).length_to_next
  end

  def lead_number_with_votes_count
    sorted_down_votes.first
  end

  def place_for_number (number)
    votes.find_by_number(number).place
  end

  protected

  def validate_votes (vote)
    raise ArgumentError.new("You mess things up, bastard.") unless votes.where(number: vote.number).empty?
    true
  end

  def never_remove (vote)
    raise ArgumentError.new("You motherfucker, never try this again!")
  end

  def fullup_votes
    0.upto(9) { |i| votes.build(number: i, votes_count: 0) }
  end

  def save_for_future
    votes.each { |v| v.save! }
  end
end
