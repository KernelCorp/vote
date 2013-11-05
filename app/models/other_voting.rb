class OtherVoting < Voting
  attr_accessible :points_limit, :cost_10_points, :actions_attributes

  has_many :actions, :foreign_key => 'voting_id', :dependent => :destroy
  accepts_nested_attributes_for :actions, :allow_destroy => :true
end
