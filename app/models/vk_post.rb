require 'net/http'

class VkPost < ActiveRecord::Base
  belongs_to :participant
  belongs_to :voting, foreign_key: :voting_id
  attr_accessible :post_id, :participant, :voting

  validates_presence_of :post_id, :participant, :voting
  validates_uniqueness_of :post_id
  validate :existence_post

  def count_likes
    post = get_post_from_vk
    post['likes']['count']
  end

  def count_reposts
    post = get_post_from_vk
    post['reposts']['count']
  end

  protected

  def get_post_from_vk
    response = Net::HTTP.get_response URI.parse("https://api.vk.com/method/wall.getById?posts=#{post_id}")
    json_response = JSON.parse(response.body)['response']
    json_response.nil? ? nil : json_response.first
  end

  def existence_post
    if get_post_from_vk.nil?
      errors.add :post_id, I18n.t('activerecord.errors.models.vk_post.post.not_exist')
    end
  end
end
