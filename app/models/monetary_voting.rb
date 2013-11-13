class MonetaryVoting < Voting
  attr_accessible :cost, :timer, :financial_threshold, :min_sum, :users_population, :budget

  def vote_for_claim (claim, count)
    claim.participant.debit! self.cost * count

    lengths = retrive_position_and_length_to_first claim.phone

    clone = lengths.sort { |a, b| a.fetch(:l) > b.fetch(:l) ? 1 : -1 }

    distribution = proc do |arr, count|
      until arr.empty? do
        min_elem = arr.pop
        val = min_elem.fetch :l
        index = min_elem.fetch :i
        if count < val
          val = count
          arr.clear
        end
        count -= val
        vote_for_number_in_position claim.phone[index], index, val
      end
    end

    distribution.call clone, count

    if count != 0
      piece = count / 10
      10.times { |i| clone << { i: i, l: piece } }
      clone[-1][:l] += count - piece * 10
      distribution.call clone, count
    end
  end
end
