When(/^I GET on "(.*?)"$/) do |path|
  visit path
end

Then(/^I should see "(.*?)"$/) do |text|
  expect(page).to have_content(text)
end
