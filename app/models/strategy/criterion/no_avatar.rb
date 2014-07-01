class Strategy::Criterion::NoAvatar < Strategy::Criterion::Base
  def match( voter, post )
    voter.has_avatar == false
  end
end
