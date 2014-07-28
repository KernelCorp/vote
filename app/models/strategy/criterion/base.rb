class Strategy::Criterion::Base < ActiveRecord::Base
  self.table_name = 'strategy_criterions'

  attr_accessible :priority, :zone, :type, :group_id

  belongs_to :strategy

  before_validation :check_sub

  AVAILABLE = %w( Friend Follower Guest Friendly NoAvatar MemberVk MemberFb )

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

  def name
    type.scan(/\w+$/).first
  end

  def option_value
    "#{name}_#{group_id}"
  end

  protected

  def check_sub
    if self.instance_of? Strategy::Criterion::Base
      becomes(type.constantize).valid?
    end
  end
end
