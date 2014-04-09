class Strategy::Criterion::Friendly < Strategy::Criterion
  def self.match( voter )
    voter.too_friendly
  end
end
