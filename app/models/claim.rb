class Claim < ActiveRecord::Base
  attr_accessible :voting, :phone

  after_create :try_to_complete_voting

  belongs_to :participant
  belongs_to :voting
  belongs_to :phone

  has_many :vote_transactions, dependent: destroy

  validates_uniqueness_of :phone_id, scope: [:voting_id]


  protected

  def try_to_complete_voting
    voting.complete_if_necessary! if voting.is_a? MonetaryVoting
  end
end
