class Strategy::Criterion::Base < ActiveRecord::Base
  self.table_name = 'strategy_criterions'

  attr_accessible :priority, :zone, :type, :group_id

  belongs_to :strategyz

  validates :type, presence: true, uniqueness: { scope: :strategy_id }

  AVAILABLE = %w( Friend Follower Guest Member Friendly NoAvatar )

  def zone
    Strategy::ZONES[read_attribute(:zone)]
  end
  def zone= (s)
    if s.is_a?(Integer) || s =~ /^\d+$/
      write_attribute :zone, s.to_i
    
    elsif s_key = Strategy::ZONES.key(s.to_sym)
      write_attribute :zone, s_key
    end
  end
end
