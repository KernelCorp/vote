class Strategy::Criterion::Guest < Strategy::Criterion
  def self.match( voter )
    voter.relationship == 'guest'
  end
end
