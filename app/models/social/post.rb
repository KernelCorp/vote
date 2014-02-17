require 'net/http'

class Social::Post < ActiveRecord::Base
  self.table_name = "social_posts"


  attr_accessible :type, :url, :post_id, :participant, :voting, :points


  belongs_to :participant
  belongs_to :voting, class_name: 'OtherVoting'


  validates :post_id, :participant, :voting, presence: true
  validates :post_id, uniqueness: { scope: [:voting_id, :type] }
  validate :origin_exist
  validate :action_exist


  before_validation :capture_post_id, on: :create


  def get_origin
    if not @loaded
      get_subclass_origin
      @loaded = true
    end

    @origin
  end

  def social_action
    voting.social_actions.find_by_type type.sub('Post', 'Action')
  rescue
    return nil
  end

  def count_points
    return -1 if get_origin == nil

    prices = social_action.prices

    return @origin[:likes] * prices[:like] + @origin[:reposts] * prices[:repost]
  end

  def likes
    get_origin != nil && @origin[:likes] || -1
  end

  def reposts
    get_origin != nil && @origin[:reposts] || -1
  end

  def text
    get_origin != nil && @origin[:text] || ''
  end

  protected

  def origin_exist
    errors.add :type, I18n.t('activerecord.errors.models.social_post.origin.not_exist') if get_origin == nil
  end

  def action_exist
    errors.add :post_id, I18n.t('activerecord.errors.models.social_post.action.not_exist') if social_action == nil
  end

  def capture_post_id
    self.post_id = self.class.capture_post_id url unless self.url.blank?
  end
end
