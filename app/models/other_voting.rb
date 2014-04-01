class OtherVoting < Voting
  attr_accessible :points_limit, :cost_10_points, 
                  :social_actions_attributes, :other_actions_attributes, :strategy_attributes,
                  :how_participate, :max_users_count,
                  :snapshot_frequency

  has_many :other_actions,   foreign_key: :voting_id, dependent: :destroy
  has_many :social_actions,  foreign_key: :voting_id, dependent: :destroy, class_name: 'Social::Action'
  has_many :social_posts,    foreign_key: :voting_id, dependent: :destroy, class_name: 'Social::Post'
  
  has_many :participants, through: :social_posts, uniq: true

  accepts_nested_attributes_for :other_actions,  allow_destroy: :true
  accepts_nested_attributes_for :social_actions, allow_destroy: :true

  has_one :strategy, foreign_key: :voting_id
  accepts_nested_attributes_for :strategy

  FREQUENCY = { 0 => :none, 1 => :daily, 2 => :hourly }

  before_create do
    build_strategy
  end

  def snapshot_frequency
    FREQUENCY[read_attribute(:snapshot_frequency)]
  end
  def snapshot_frequency= (s)
    if s.is_a? Integer
      write_attribute :snapshot_frequency, s
    elsif s =~ /^\d+$/ && (0..2).include?(s.to_s.to_i)
      write_attribute :snapshot_frequency, s.to_s.to_i
    elsif FREQUENCY.key(s.to_sym)
      write_attribute :snapshot_frequency, FREQUENCY.key(s.to_sym)
    end
  end

  def sorted_participants
    if participants.count == 1
      p = participants.first
      p.points = participant_points p
      return [p]
    end
    participants.sort do |x,y|
      x.points = participant_points x
      y.points = participant_points y
      - (x.points <=> y.points)
    end
  end

  def sorted_posts
    social_posts.sort do |x, y|
      - (x.count_points <=> y.count_points)
    end
  end

  def participant_points( participant )
    social_posts.where( participant_id: participant.id ).inject(0) { |total_points, post| total_points += post.count_points }
  end

  def population
    participants.size 
  end

  def fresh?
    population == 0
  end

  def complete!
    super
    social_posts.each do |post|
      post.points = post.count_points
      post.participant.add_funds! post.points if post.points > 0
      post.save
    end
  end

  def social_snapshot
    social_posts.all.each do |post|
      post.snapshot.save
    end
  end

  protected

  def need_complete?
    need_complete = case way_to_complete
                      when 'count_users'  then max_users_count <= participants.count
                      when 'count_points' then budget <= current_sum
                      when 'date'         then read_attribute(:end_date) <= DateTime.now
                    end

    need_complete && status == :active
  end

  def current_sum
    social_posts.inject { |sum, post| sum + post.count_points }
  end

end
