require 'net/http'

class VkPost < ActiveRecord::Base
  belongs_to :participant
  belongs_to :voting, foreign_key: :voting_id
  attr_accessible :post_id, :participant, :voting, :result, :url

  validates_presence_of :post_id, :participant, :voting
  validates_uniqueness_of :post_id
  validate :existence_post

  before_validation :set_post_id

  def count_likes
    post = get_post_from_vk
    post.nil? ? -1 : post['likes']['count']
  end

  def count_reposts
    post = get_post_from_vk
    post.nil? ? -1 : post['reposts']['count']
  end

  def text
    post = get_post_from_vk
    post.nil? ? -1 : post['text']
  end

  def self.url_to_id(url)
    url.gsub /.*wall((-?\d+_?\d*)?).*/, "\\1"
  end

  def get_post_from_vk
    return @post if @is_post_load
    response = Net::HTTP.get_response URI.parse("http://api.vk.com/method/wall.getById?posts=#{post_id}")
    json_response = JSON.parse(response.body)['response']
    @is_post_load = true
    @post = json_response.nil? ? nil : json_response.first
  end

  protected

  def existence_post
    if get_post_from_vk.nil?
      errors.add :post_id, I18n.t('activerecord.errors.models.vk_post.post.not_exist')
    end
  end

  def set_post_id
    self.post_id = VkPost.url_to_id url unless self.url.blank?
  end
end
