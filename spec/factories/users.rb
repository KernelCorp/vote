FactoryGirl.define do

  factory :admin, class: AdminUser do
    email 'admin@example.com'
    password 'password'
  end

end
