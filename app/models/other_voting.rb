class OtherVoting < Voting
  attr_accessible :points_limit, :cost_10_points, 
                  :social_actions_attributes, :other_actions_attributes,
                  :how_participate, :max_users_count

  has_many :other_actions,   foreign_key: :voting_id, dependent: :destroy
  has_many :social_actions,  foreign_key: :voting_id, dependent: :destroy, class_name: 'Social::Action'
  has_many :social_posts,    foreign_key: :voting_id, dependent: :destroy, class_name: 'Social::Post'
  
  has_many :participants, through: :social_posts

  accepts_nested_attributes_for :other_actions,  allow_destroy: :true
  accepts_nested_attributes_for :social_actions, allow_destroy: :true

  
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
    social_posts.where( participant: participant ).inject(0) { |total_points, post| total_points += post.count_points }
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

  protected

  def need_complete?
    need_complete = case way_to_complete
                      when 'count_users'  then max_users_count <= participants.count
                      when 'count_points' then budget <= current_sum
                      when 'date'         then read_attribute(:end_date) <= DateTime.now
                    end

    need_complete && status == :active
  end
end
