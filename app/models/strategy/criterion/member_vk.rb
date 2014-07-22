class Strategy::Criterion::MemberVk < Strategy::Criterion::Base
  def match( voter, post )
    if post.is_a?(Social::Post::Vk) && !group_id.blank?
      get_group_members.include? voter.social_id.to_i
    end
  end

  protected

  def get_group_members
    Rails.cache.fetch "group_members_vk_#{group_id}", expires_in: 12.hour do
      Social::Post::Vk.get_group_members group_id
    end
  end
end
