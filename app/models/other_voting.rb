class OtherVoting < Voting
  attr_accessible :points_limit, :cost_10_points, :actions_attributes

  has_many :actions, :foreign_key => 'voting_id', :dependent => :destroy
  accepts_nested_attributes_for :actions, :allow_destroy => :true

  protected
  def need_complete?
    strangers = Stranger.joins(:done_things).where(what_dones: { voting_id: self.id }).uniq.all
    strangers.sort_by { |s| s.points}
    (strangers.first.points >= self.points_limit) || (read_attribute(:end_date) <= DateTime.now)
  end
end
