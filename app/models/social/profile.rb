class Social::Profile < ActiveRecord::Base
  self.table_name = "social_profiles"

  belongs_to :participant
end
