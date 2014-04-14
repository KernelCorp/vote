class Social::State < ActiveRecord::Base
  self.table_name = 'social_states'


  attr_accessible :likes, :reposts
  def liked() self.likes end
  def reposted() self.reposts end


  belongs_to :post, class_name: 'Social::Post'

  has_and_belongs_to_many :voters, class_name: 'Social::Voter'
end
