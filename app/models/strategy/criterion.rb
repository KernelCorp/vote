class Strategy::Criterion < ActiveRecord::Base
  self.table_name = 'strategy_criterions'

  attr_accessible :priority, :zone, :type

  belongs_to :strategy

  validates :type, presence: true, uniqueness: { scope: :strategy_id }

  AVAILABLE = %w( Friend Follower Guest Friendly NoAvatar )

  def match( voter )
    self.class.match voter
  end
end
