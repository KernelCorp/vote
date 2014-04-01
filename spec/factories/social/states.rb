FactoryGirl.define do
  factory :state, class: Social::State do
    likes 4
    reposts 2
    voters {[FactoryGirl.create(:voter, liked: true, reposted: false, relationship: 'friend', has_avatar: true, too_friendly: false),
             FactoryGirl.create(:voter, liked: true, reposted: false, relationship: 'follower', has_avatar: true, too_friendly: true),
             FactoryGirl.create(:voter, liked: true, reposted: false, relationship: 'guest', has_avatar: false, too_friendly: true)
           ]}
  end
end
