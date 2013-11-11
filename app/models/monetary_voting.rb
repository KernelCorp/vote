class MonetaryVoting < Voting
  attr_accessible :cost, :timer, :financial_threshold, :min_sum, :users_population, :budget

  def vote_for_claim (claim, count)
    claim.participant.debit! self.cost * count
    lengths = self.retrive_lengths_to_first claim.phone
    clone = lengths.sort.reverse
    until clone.empty? do
      min = clone.pop
      index = lengths.index(min) && lengths.delete_at(index)
      if count < min
        min = count
        clone.clear
      end
      count -= min
      self.vote_for_number_in_position claim.phone[index], index, min
    end
    if count != 0
      div = count / 10
      10.times do |i|
        self.vote_for_number_in_position claim.phone[i], i, div
      end
    end
    true
  end
end
