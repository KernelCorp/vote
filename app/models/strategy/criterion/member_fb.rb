require 'net/http'
require 'nokogiri'
require 'open-uri'

class Strategy::Criterion::MemberFb < Strategy::Criterion::Base
  cattr_accessor :FB, instance_accessor: false do
    access = ActiveRecord::Base.connection.table_exists?('settings') &&
        Setting.where( key: 'FacebookAccess' ).first.try(:value)

    if access.blank?
      { api: Koala::Facebook::API.new( nil ), expires: 0 }
    else
      access = JSON.parse access
      {
          api: Koala::Facebook::API.new(access['access_token']),
          expires: access['expires']
      }
    end
  end
  validate :can_get_members

  def match( voter, post )
    if post.is_a?(Social::Post::Fb) && !group_id.blank?
      get_group_members.include? voter.social_id
    end
  end

  protected

  def get_ids( object_id, method, fields, &block )
    result = []
    data = @@FB[:api].get_connections object_id, method, { limit: 100, fields: fields }, api_version: 'v2.0'
    while !data.blank?
      data.each do |info|
        result << block.call(info).to_s
      end
      data = data.next_page
    end
    result
  end

  def get_group_members
    # Rails.cache.fetch "group_members_fb_#{group_id}", expires_in: 12.hour do

      if group_id.match /^http/
        url = URI("http://lookup-id.com?fbtype=group&fburl=#{group_id}&action=commit")
        # url.query = URI.encode_www_form({fbtype: 'group', fburl: group_id, action: 'commit'})
        res = Net::HTTP.post_form(url, fbtype: 'group', fburl: group_id, check: 'submit')
        doc = Nokogiri::HTML(res.body)
        real_id = ''
        doc.css('#code').each do |container|
          real_id = container.content
        end
        write_attribute :group_id, real_id
      end
    members = get_ids(group_id, 'members', 'id'){ |member| member['id'] }
    members
    # end
  rescue
    []
  end

  def can_get_members
    errors.add :group_id, :cant_get_members if get_group_members.size == 0
  end
end
