class Strategy::Criterion::Guest < Strategy::Criterion::Base
  def self.match( voter )
    voter.relationship == 'guest'
  end
end
