When(/^I GET request for "(.*?)"$/) do |path|
  get path
end

Then(/^the status is (\d+)$/) do |status_code|
  expect(last_response.status).to eq status_code.to_i
end

Then(/^I should see "(.*?)"$/) do |text|
  expect(last_response).to match text
end
