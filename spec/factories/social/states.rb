FactoryGirl.define do
  factory :state, class: Social::State do
    likes 1
    reposts 0
    voters {[FactoryGirl.create(:voter, relationship: 'friend', has_avatar: true, too_friendly: false),
             FactoryGirl.create(:voter, relationship: 'subscriber', has_avatar: true, too_friendly: true),
             FactoryGirl.create(:voter, relationship: 'unknown', has_avatar: false, too_friendly: true)
           ]}
  end
end
