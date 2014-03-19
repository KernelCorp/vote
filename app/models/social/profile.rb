class Social::Profile < ActiveRecord::Base
  self.table_name = "social_profiles"

  attr_accessible :provider, :uid 

  belongs_to :participant
end
