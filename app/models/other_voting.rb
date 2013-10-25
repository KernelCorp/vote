class OtherVoting < Voting
  has_many :actions, dependent: destroy
end