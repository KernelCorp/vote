FactoryGirl.define do
  factory :voting, class: OtherVoting do
    status :active
    name 'Great Voting'
    description 'The best voting ever.'
    way_to_complete 'date'
    start_date Date.today + 2.day
    end_date Date.today + 5.day
    association :organization, is_confirmed: true
    association :strategy, factory: :strategy, red: 0.1, yellow: 0.5, green: 1
    after(:create) do |voting|
      create_list(:action_vk, 1, voting: voting)
      create_list(:post_vk, 1, voting: voting)
    end

  end
end
