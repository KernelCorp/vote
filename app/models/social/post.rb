require 'net/http'

class Social::Post < ActiveRecord::Base
  self.table_name = 'social_posts'


  attr_accessible :type, :url, :post_id, :participant, :voting, :points, :omniauth
  attr_accessor :omniauth


  has_many :states, class_name: 'Social::State'


  belongs_to :participant
  belongs_to :voting, class_name: 'OtherVoting'


  validates :type, :url, :post_id, :participant, :voting, presence: true
  validates :post_id, uniqueness: { scope: [:voting_id, :type] }
  validate :snapshot_valid
  validate :action_exist


  before_validation :post_id_from_url, on: :create

  def social_action
    voting.social_actions.find_by_type type.sub('Post', 'Action')
  rescue
    nil
  end

  def snapshot
    info = snapshot_info

    return nil unless info

    shot = states.build info[:state]
    info[:voters].each do |voter_info|
      shot.voters.build voter_info
    end

    shot
  end

  def count_points
    if states.count > 0
      count_like_points + count_repost_points
    else
      prices = social_action.prices
      shot = snapshot_info
      shot[:state][:likes] * prices[:like] + shot[:state][:reposts] * prices[:repost]
    end
  end

  def count_like_points
    ( states.count > 0 ? voting.strategy.likes_for_zone(:all, states.last) : snapshot[:state][:likes] ) * social_action.prices[:like]
  end

  def count_repost_points
    ( states.count > 0 ? voting.strategy.reposts_for_zone(:all, states.last) : snapshot[:state][:reposts] ) * social_action.prices[:repost]
  end

  protected

  def snapshot_valid
    if post_id.blank?
      errors.add :url, I18n.t('activerecord.errors.models.social_post.url.id_not_detected')
    else
      errors.add :url, I18n.t('activerecord.errors.models.social_post.url.origin_not_found') unless post_exist?
    end
  end

  def action_exist
    if voting.social_actions.where( type: type.sub('Post', 'Action') ).length == 0
      errors.add :type, I18n.t('activerecord.errors.models.social_post.type.action_not_exist')
    end
  end

  def post_id_from_url
    self.post_id = self.class.post_id_from_url url if !type.blank? && !url.blank?
  end
end
