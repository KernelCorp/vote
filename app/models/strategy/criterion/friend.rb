class Strategy::Criterion::Friend < Strategy::Criterion
  def self.match( voter )
    voter.relationship == 'friend'
  end
end
