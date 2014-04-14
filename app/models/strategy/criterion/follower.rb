class Strategy::Criterion::Follower < Strategy::Criterion::Base
  def self.match( voter )
    voter.relationship == 'follower'
  end
end
