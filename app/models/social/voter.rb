class Social::Voter < ActiveRecord::Base
  self.table_name = 'social_voters'


  attr_accessible :reposted, :liked, :url, :relationship, :has_avatar, :too_friendly, :zone, :post_id
  attr_accessor :criterion


  scope :likers,    -> { where liked: true }
  scope :reposters, -> { where reposted: true }


  belongs_to :post, class_name: 'Social::Post'

  has_and_belongs_to_many :states, class_name: 'Social::State'


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
