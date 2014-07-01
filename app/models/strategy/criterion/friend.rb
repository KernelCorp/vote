class Strategy::Criterion::Friend < Strategy::Criterion::Base
  def match( voter, post )
    voter.relationship == 'friend'
  end
end
