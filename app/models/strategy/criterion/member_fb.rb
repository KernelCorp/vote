class Strategy::Criterion::MemberFb < Strategy::Criterion::Base
  def match( voter, post )
    if post.is_a?(Social::Post::Fb) && !group_id.blank?
      get_group_members.include? voter.social_id
    end
  end

  protected

  def get_group_members
    Rails.cache.fetch "group_members_fb_#{group_id}", expires_in: 12.hour do
      fb = Social::Post::Fb.FB[:api]

      gid = fb.fql_query "SELECT id FROM profile WHERE username = \"#{group_id}\" OR id = \"#{group_id}\""

      members = fb.fql_query "SELECT uid FROM group_member WHERE gid = \"#{gid[0]['id']}\""

      members.map{ |member| member['uid'] }
    end
  end
end
