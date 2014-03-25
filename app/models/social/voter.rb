class Social::Voter < ActiveRecord::Base
  self.table_name = 'social_voters'

  attr_accessible :url, :reposted, :relationship, :avatared, :too_friendly

  belongs_to :state, class_name: 'Social::Voter'
end
