class OtherVoting < Voting
  attr_accessible :points_limit, :cost_10_points, :actions_attributes

  has_many :actions,  foreign_key: :voting_id, dependent: :destroy
  has_many :vk_posts, foreign_key: :voting_id, dependent: :destroy
  has_many :participants, through: :vk_posts
  accepts_nested_attributes_for :actions, :allow_destroy => :true

  def sorted_participants
    participants.sort {|x,y| count_point_for(x) <=> count_point_for(y)}
  end

  def count_point_for(participant)
    posts = vk_posts.where(participant_id: participant)
    sum = 0
    posts.each { |post| sum = post.count_likes + post.count_reposts}
    sum
  end

  protected

  def need_complete?
    strangers = Stranger.joins(:done_things).where(what_dones: { voting_id: self.id }).uniq.all
    strangers.sort_by { |s| s.points}
    (strangers.first.points >= self.points_limit) || (read_attribute(:end_date) <= DateTime.now)
  end
end
