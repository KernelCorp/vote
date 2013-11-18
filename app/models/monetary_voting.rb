class MonetaryVoting < Voting
  attr_accessible :cost, :timer, :financial_threshold, :min_sum, :users_population, :budget, :max_users_count

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
      clone.last[:l] += count - piece * 10
      distribution.call clone, count
    end
    complete_if_necessary!
  end

  def complete_if_necessary!
    if need_complete?
      update_attribute :status, 2
      return true
    end
    return false
  end

  protected
  def need_complete?
    return false if [:prizes, :closed].include? status
    case way_to_complete
      when 'count_users' then max_users_count <= (claims.group_by { |claim| claim.participant.id}).count
      when 'sum'         then budget <= get_current_sum
    end
  end

  def get_current_sum
    sum = claims.count * cost
    phone.positions.each do |pos|
      pos.votes.each {|v| sum += v.votes_count}
    end
    sum
  end


end
