FactoryGirl.define do
  factory :strategy, class: Strategy do
    no_avatar_zone 1
    friends_zone 0
    subscriber_zone 1
    unknown_zone 2
    too_friendly_zone 1
    red 0.1
    yellow 0.5
    green 1
  end
end
