When(/^I GET on "(.*?)"$/) do |path|
  visit path
end

Then(/^the status is (\d+)$/) do |status_code|
  expect(page.status_code).to eq status_code.to_i
end

Then(/^I should see "(.*?)"$/) do |text|
  expect(page).to have_content(text)
end
