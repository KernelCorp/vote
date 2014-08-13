FactoryGirl.define do
  factory :criterion_friend, class: Strategy::Criterion::Friend do

  end
  factory :strategy, class: Strategy do
    red 0.1
    yellow 0.5
    green 1
    criterions {[FactoryGirl.create(:criterion_friend)]}
  end
end


