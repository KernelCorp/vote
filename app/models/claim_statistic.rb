class ClaimStatistic < ActiveRecord::Base
  belongs_to :claim
  attr_accessible :claim_id, :place

  def self.get_lead_claim_for_voting (voting)
    ClaimStatistic.joins(:claim).where(claims: {voting_id: voting.id}, place: 1).sort_by(&:created_at).last.claim
  end

end
