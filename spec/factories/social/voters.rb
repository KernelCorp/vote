FactoryGirl.define do
  factory :voter, class: Social::Voter do
    relationship 'subscriber'
    has_avatar 1
    too_friendly 1
  end
end
