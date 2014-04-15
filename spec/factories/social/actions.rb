FactoryGirl.define do
  factory :action_vk, class: Social::Action::Vk do
    like_points 2
    repost_points 3
  end

  factory :social_action, class: Social::Action::Base do
    like_points 1
    repost_points 1

    factory :vk_action, class: Social::Action::Vk
    factory :fb_action, class: Social::Action::Fb
    factory :tw_action, class: Social::Action::Tw
    factory :mm_action, class: Social::Action::Mm
    factory :ok_action, class: Social::Action::Ok
  end
end
