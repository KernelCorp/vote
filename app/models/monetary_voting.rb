class MonetaryVoting < Voting
  attr_accessible :cost, :timer, :financial_threshold, :min_sum, :budget, :max_users_count

  validates :max_users_count,
            numericality: { greater_than: 0 },
            if: ->(v) { v.way_to_complete == 'count_users' }
  validates :budget,
            numericality: { greater_than: 0 },
            if: ->(v) { v.way_to_complete == 'sum' }
  validates :end_date,
            presence: true,
            allow_blank: false,
            if: ->(v) { v.way_to_complete == 'date' }

  def vote_for_claim (claim, count)
    claim.participant.debit! count
    lengths = retrive_position_and_length_to_first(claim.phone) { |l| l != -1 }

    clone = lengths.sort_by { |a| a.fetch(:l) }
    distribution = proc do
      until clone.empty? do
        min_elem = clone.shift
        val = min_elem.fetch :l
        index = min_elem.fetch :i
        if count <= val
          val = count
          clone.clear
        end
        count -= val
        vote_for_number_in_position claim.phone[index], index, val
      end
    end

    distribution.call

    if count != 0
      piece = count / 10
      10.times { |i| clone << { i: i, l: piece } }
      clone.last[:l] += count - piece * 10
      distribution.call
    end
    complete_if_necessary!
  end

  def complete_if_necessary!
    if need_complete?
      complete!
      return true
    end
    return false
  end

  def complete!
    update_attribute :status, 2
  end

  def can_vote_for_claim?
    status == :active && (read_attribute(:end_timer).nil? || read_attribute(:end_timer) > DateTime.now)
  end

  def can_register_for_voting?
    status == :active && read_attribute(:end_timer).nil?
  end

  def lead_claim
    claims.sort_by { |c| determine_place(c.phone) }.first
  end

  def fresh?
    current_sum == claims.size * cost
  end

  def vote_for_number_in_position (number, position, count)
    n = phone[position].votes.find_by_number(number)
    n.votes_count += count
    n.save!
  end

  def determine_place (phone)
    phones = []

    all_phones = self.claims.map { |c| c.phone.number }

    pre_phones = all_phones.group_by { |p| matches_count p }
    # Go for each key(sorted big to small), get elements and sort to make first one to be that, which has most number of votes
    pre_phones.keys.sort.reverse.each do |key|
      phones << pre_phones[key].sort_by { |elem| self.phone.votes_count_for_phone_number elem }.reverse
    end

    phones.flatten!

    phone = phone.number if phone.is_a? Phone
    place = phones.index phone
    place.nil? ? 0 : place + 1
  end

  def positions_and_lengths_to_upper_places_for_phone (phone_number)
    pls = self.retrive_position_and_length_to_first(phone_number) { |l| l != -1 }
    result = []

    pls.sort_by! { |pl| pl[:l] }.length.times do |i|
      count = result.last.nil? ? 0 : result.last.fetch(:l)
      indexs = result.last.nil? ? [] : result.last.fetch(:i).clone
      count += pls[i].fetch(:l)
      indexs << pls[i].fetch(:i)
      result.push({ i: indexs, l: count })
    end
    result.reverse!
  end

  def sorted_phone_numbers_for_participant (participant)
    phones = participant.claims.where(voting_id: self.id).map &:phone
    phones.sort_by { |phone| matches_count(phone) }
  end

  def ratings_for_phones (phone_numbers)
    ratings = []
    phone_numbers.each_with_index { |pn, i| ratings.push rating_for_phone(pn) }
    ratings
  end

  def rating_for_phone (phone_number)
    rating = []
    phone_number.each_with_index { |n, i| rating.push phone[i].place_for_number(n) }
    rating
  end

  def matches_count (phone_number)
    leader = phone.lead_phone_number
    count = 0
    leader.each_with_index { |p, i| count += 1 if p == phone_number[i].to_i }
    count
  end

  protected

  def need_complete?
    need_complete = case way_to_complete
                      when 'count_users'  then max_users_count <= claims.group_by { |claim| claim.participant.id }.size
                      when 'sum'          then budget <= current_sum
                      when 'date'         then read_attribute(:end_date) <= DateTime.now
                    end
    need_complete && read_attribute(:end_timer).nil? && set_end_timer!
    need_complete && !can_vote_for_claim?
  end

  def current_sum
    sum = claims.size * cost
    phone.positions.each do |pos|
      pos.votes.each { |v| sum += v.votes_count }
    end
    sum
  end

  def set_end_timer!
    voting = self
    update_attribute :end_timer, DateTime.now + timer.minutes

    threads = []
    voting.claims.map(&:participant).each do |p|
      thread = Thread.new do
        mail = ParticipantMailer.timer(voting, p)
        mail.deliver unless mail.nil?
      end
      threads << thread
    end
    threads.each { |t| t.join 0 }

    t = Thread.new do
      sleep voting.timer.minutes - 1.seconds # Need some magic
      voting.complete!
      voting.snapshot
    end
    t.join 0

    true
  end


end
