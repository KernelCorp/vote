When /^I filled phone's input$/ do
  pool = ('0'..'9').to_a
  10.times do |i|
    fill_in "add_number[n_#{i + 1}]", :with => pool.shuffle.first
  end
end

When /^I click to button '(.*)'$/ do |button|
  find("##{button}").click
end

Then /^I should see response (.*)$/ do |status|
  page.should have_content(status)
end

Then /^I should see sign in form$/ do
  page.should have_css('#form_sign_in')
end

Then /^I should see sign up form$/ do
  page.should have_css('#form_sign_up')
end

Then /^I should see input for "(.*)"$/ do |field_name|
  page.should have_css("input##{field_name}")
end
