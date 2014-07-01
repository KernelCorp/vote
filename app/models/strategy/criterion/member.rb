class Strategy::Criterion::Member < Strategy::Criterion::Base
  def match( voter, post )
    if post.is_a?(Social::Post::Vk) && !args.blank?
      get_group_members.include? voter.social_id
    end
  end

  protected

  def get_group_members
    Rails.cache.fetch "group_members_#{args}", expires_in: 12.hour do
      Social::Post::Vk.get_group_members args
    end
  end
end
