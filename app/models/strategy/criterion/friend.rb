class Strategy::Criterion::Friend < Strategy::Criterion::Base
  def self.match( voter )
    voter.relationship == 'friend'
  end
end
