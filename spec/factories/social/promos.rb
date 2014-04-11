FactoryGirl.define do
  factory :promo do
    code 'code'
    date_end DateTime.now
  end
end