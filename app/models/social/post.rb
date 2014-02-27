require 'net/http'

class Social::Post < ActiveRecord::Base
  self.table_name = "social_posts"


  attr_accessible :type, :url, :post_id, :participant, :voting, :points, :omniauth
  attr_accessor :omniauth


  belongs_to :participant
  belongs_to :voting, class_name: 'OtherVoting'


  validates :type, :url, :post_id, :participant, :voting, presence: true
  validates :post_id, uniqueness: { scope: [:voting_id, :type] }
  validate :origin_exist
  validate :action_exist


  before_validation :post_id_from_url, on: :create


  def get_origin
    unless @loaded
      @origin = get_subclass_origin
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
    do_with_check_original(-1) do
      prices = social_action.prices
      @origin[:likes] * prices[:like] + @origin[:reposts] * prices[:repost]
    end
  end

  def likes
    do_with_check_original(-1) { @origin[:likes] }
  end

  def reposts
    do_with_check_original(-1) { @origin[:reposts] }
  end

  def text
    do_with_check_original('') { @origin[:text] }
  end

  protected

  def do_with_check_original(default = nil, &block)
    return default if get_origin.nil?
    yield
  end

  def origin_exist
    if post_id.blank?
      errors.add :url, I18n.t('activerecord.errors.models.social_post.url.id_not_detected')
    else
      errors.add :url, I18n.t('activerecord.errors.models.social_post.url.origin_not_found') if get_origin == nil
    end
  end

  def action_exist
    errors.add :type, I18n.t('activerecord.errors.models.social_post.type.action_not_exist') if social_action == nil
  end

  def post_id_from_url
    self.post_id = self.class.post_id_from_url url if !type.blank? && !url.blank?
  end
end
