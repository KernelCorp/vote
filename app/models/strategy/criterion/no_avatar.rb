class Strategy::Criterion::NoAvatar < Strategy::Criterion
  def self.match( voter )
    voter.has_avatar == false
  end
end
