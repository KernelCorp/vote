class Strategy::Criterion::Friendly < Strategy::Criterion::Base
  def self.match( voter )
    voter.too_friendly
  end
end
