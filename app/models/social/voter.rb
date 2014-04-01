class Social::Voter < ActiveRecord::Base
  self.table_name = 'social_voters'

  attr_accessible :reposted, :liked, :url, :relationship, :has_avatar, :too_friendly
  attr_accessor :zone

  belongs_to :state, class_name: 'Social::Voter'

  scope :likers,    -> { where liked: true }
  scope :reposters, -> { where reposted: true }
end
