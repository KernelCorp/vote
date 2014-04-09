class Strategy::Criterion::Follower < Strategy::Criterion
  def self.match( voter )
    voter.relationship == 'follower'
  end
end
