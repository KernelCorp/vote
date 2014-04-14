class Social::Action < ActiveRecord::Base
  self.table_name = 'social_actions'


  attr_accessible :voting, :type, :like_points, :repost_points


  belongs_to :voting, class_name: 'OtherVoting'


  validates :type, :like_points, :repost_points, presence: true
  validates :type, uniqueness: { scope: :voting_id }
  validate :social_available


  AVAILABLE = %w( Vk Fb Tw Mm Ok )


  def prices
    { like: like_points, repost: repost_points }
  end

  protected

  def social_available
    t = type.scan(/[^:]+$/).first
    errors.add :type, "не поддерживаемая социальная сеть #{t}" unless AVAILABLE.include? t
  end
end
