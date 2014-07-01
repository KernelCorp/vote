class Strategy::Criterion::Guest < Strategy::Criterion::Base
  def match( voter, post )
    voter.relationship == 'guest'
  end
end
