class Strategy::Criterion::Member < Strategy::Criterion::Base
  def self.match( voter )
    voter.relationship == 'member'
  end
end
