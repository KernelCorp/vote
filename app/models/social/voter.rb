class Social::Voter < ActiveRecord::Base
  self.table_name = 'social_voters'

  attr_accessible :reposted, :liked, :url, :relationship, :has_avatar, :too_friendly

  belongs_to :state, class_name: 'Social::Voter'
end
