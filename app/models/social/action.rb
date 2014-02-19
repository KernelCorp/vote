class Social::Action < ActiveRecord::Base
  self.table_name = "social_actions"


  attr_accessible :voting, :type, :like_points, :repost_points


  belongs_to :voting, class_name: 'OtherVoting'


  validates :type, uniqueness: { scope: :voting_id }


  AVAILABLE = %w( Social::Action::Vk Social::Action::Fb Social::Action::Tw )


  def prices
    { like: like_points, repost: repost_points }
  end
end
