FactoryGirl.define do
  factory :vk_action, class: Social::Action::Vk do
    like_points 2
    repost_points 3
  end
end
