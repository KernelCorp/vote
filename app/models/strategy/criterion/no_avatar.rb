class Strategy::Criterion::NoAvatar < Strategy::Criterion::Base
  def self.match( voter )
    voter.has_avatar == false
  end
end
