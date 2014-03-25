require 'net/http'

class Social::Post < ActiveRecord::Base
  self.table_name = 'social_posts'


  attr_accessible :type, :url, :post_id, :participant, :voting, :points, :omniauth
  attr_accessor :omniauth


  belongs_to :participant
  belongs_to :voting, class_name: 'OtherVoting'


  validates :type, :url, :post_id, :participant, :voting, presence: true
  validates :post_id, uniqueness: { scope: [:voting_id, :type] }
  validate :snapshot_valid
  validate :action_exist


  before_validation :post_id_from_url, on: :create

  def snapshot
    info = snapshot_info
    puts 11
    snapshot = self.states.build info[:state]
    info[:voters].each do |voter_info|
      snapshot.voters.build voter_info
    end
    return snapshot
  rescue
    return nil
  end

  protected

  def snapshot_valid
    if post_id.blank?
      errors.add :url, I18n.t('activerecord.errors.models.social_post.url.id_not_detected')
    else
      errors.add :url, I18n.t('activerecord.errors.models.social_post.url.origin_not_found') if snapshot == nil
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
