class MonetaryVoting < Voting
  attr_accessible :cost, :timer, :financial_threshold, :min_sum, :users_population, :budget, :max_users_count

  def vote_for_claim (claim, count)
    claim.participant.debit! count
    lengths = retrive_position_and_length_to_first(claim.phone) { |l| l != -1 }

    clone = lengths.sort_by { |a| a.fetch(:l) }
    distribution = proc do |arr, count|
      until arr.empty? do
        min_elem = arr.shift
        val = min_elem.fetch :l
        index = min_elem.fetch :i
        if count <= val
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
      set_end_timer!
      return true
    end
    return false
  end

  def can_vote_for_claim?
    status == :active || read_attribute(:end_timer) >= DateTime.now
  end

  protected

  def need_complete?
    return false if [:prizes, :closed].include? status
    case way_to_complete
      when 'count_users'  then max_users_count <= (claims.group_by { |claim| claim.participant.id }).count
      when 'sum'          then budget <= get_current_sum
      when 'date'         then end_date <= DateTime.now
    end
  end

  def get_current_sum
    sum = claims.count * cost
    phone.positions.each do |pos|
      pos.votes.each { |v| sum += v.votes_count }
    end
    sum
  end

  def set_end_timer!
    write_attribute :end_timer, DateTime.now + timer.to_i / (24.0 * 60.0)
  end

end
