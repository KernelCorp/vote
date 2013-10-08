class Voting < ActiveRecord::Base
  attr_accessible :name, :positions, :start_date

  belongs_to :organization
  composed_of :phone

end
