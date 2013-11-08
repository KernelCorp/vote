class MonetaryVoting < Voting
  attr_accessible :cost, :timer, :financial_threshold, :min_sum, :users_population, :budget

  def vote_for_claim (claim, count)
    claim.participant.debit! self.cost * count
    
  end
end
