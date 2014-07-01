class Strategy::Criterion::Friendly < Strategy::Criterion::Base
  def match( voter, post )
    voter.too_friendly
  end
end
