Then(/^I should see "(.*?)"$/) do |text|
  expect(last_response).to match text
end
