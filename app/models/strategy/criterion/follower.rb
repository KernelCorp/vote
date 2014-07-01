class Strategy::Criterion::Follower < Strategy::Criterion::Base
  def match( voter, post )
    voter.relationship == 'follower'
  end
end
