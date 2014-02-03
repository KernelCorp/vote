class OtherVoting < Voting
  attr_accessible :points_limit, :cost_10_points, :cost_of_like,
                  :cost_of_repost, :actions_attributes,
                  :how_participate, :max_users_count

  has_many :actions,  foreign_key: :voting_id, dependent: :destroy
  has_many :vk_posts, foreign_key: :voting_id, dependent: :destroy
  has_many :participants, through: :vk_posts
  accepts_nested_attributes_for :actions, :allow_destroy => :true

  validates_presence_of :cost_of_like, :cost_of_repost

  def sorted_participants
    if participants.count == 1
      p = participants.first
      p.points = count_point_for participants.first
      return [p]
    end
    participants.sort do |x,y|
      x.points = count_point_for(x)
      y.points = count_point_for(y)
      - (x.points <=> y.points)
    end
  end

  def count_point_for(participant)
    posts = vk_posts.where(participant_id: participant)
    sum = 0
    posts.each { |post| sum += cost_of(post) }
    sum
  end

  def cost_of(post)
    post.count_likes * cost_of_like + post.count_reposts * cost_of_repost
  end

  def count_reposts_for (participant)
    posts = vk_posts.where participant_id: participant
    sum = 0
    posts.each { |p| sum += p.count_reposts }
    sum
  end

  def population; participants.size end

  def votes_count
    #TODO implement votes count for other votings
    0
  end

  def fresh?
    population == 0
  end

  def complete!
    super
    vk_posts.each do |post|
      post.result = cost_of post
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
    need_complete
  end
end
