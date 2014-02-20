FactoryGirl.define do
  factory :social_post, class: Social::Post do

    voting { OtherVoting.first }
    participant { Participant.first }

    factory :vk_post, class: Social::Post::Vk

    factory :fb_post, class: Social::Post::Fb

    factory :tw_post, class: Social::Post::Tw

    factory :mm_post, class: Social::Post::Mm
  end
end
