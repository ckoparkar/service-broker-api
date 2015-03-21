Before do
  @databases = Set.new
end

Then(/^I should see "(.*?)"$/) do |text|
  expect(last_response).to match text
end

When /^I send GET request to "([^"]*)"/ do |path|
  get path
end

When(/^I create a service instance with :instance_id (\d+)$/) do |instance_id|
  path = "/v2/service_instances/#{instance_id}"
  
  postgresql_service = double
  expect(PostgresHelper).to receive(:new).and_return(postgresql_service)

  if @databases.nil?
    expect(postgresql_service).to receive(:create_database).and_raise(ServerNotReachableError)
  elsif @databases.member? path
    expect(postgresql_service).to receive(:create_database).and_raise(DatabaseAlreadyExistsError)
  else
    @databases << path
    expect(postgresql_service).to receive(:create_database).and_return(path)
  end

  put path
end

When(/^the server is not reachable$/) do
  @databases = nil
end

Then /^the response status should be "([^"]*)"$/ do |status|
  expect(last_response.status).to eq status.to_i
end
