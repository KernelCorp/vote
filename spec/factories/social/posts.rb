FactoryGirl.define do
  factory :post_vk, class: Social::Post::Vk do
    url 'http://vk.com/feed?w=wall-34580489_20875'
    post_id '-34580489_20875'
    states  {[FactoryGirl.create(:state)]}
    association :participant
  end
end
