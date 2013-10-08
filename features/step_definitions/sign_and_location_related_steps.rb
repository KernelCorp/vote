Given /^I sign in as participant$/ do
  email = 'test@email.com'
  password = 'cucumber'
  login = 'cucum'
  @p = Participant.create!({ :login => login, :password => password, :email => email })
  visit '/users/sign'
  within '#form_sign_in' do
    fill_in 'user[email]', :with => email
    fill_in 'user[password]', :with => password
  end
  click_button 'Sign in'
end

Given /^I don't sign in$/ do
  delete 'users/sign_out'
  @p = nil
end

When /^I go to "(.*)"$/ do |url|
  visit url
end
