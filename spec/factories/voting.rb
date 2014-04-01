FactoryGirl.define do
  factory :voting, class: OtherVoting do
    states  {[FactoryGirl.create(:state)]}
    voters  {[FactoryGirl.create(:voter, relationship: 'friend', has_avatar: true, too_friendly: false),
              FactoryGirl.create(:voter, relationship: 'subscriber', has_avatar: true, too_friendly: true),
              FactoryGirl.create(:voter, relationship: 'unknown', has_avatar: false, too_friendly: true)
    ]}
    strategy {FactoryGirl.create(:strategy)}

  end
end
