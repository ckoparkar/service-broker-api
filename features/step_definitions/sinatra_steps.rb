Before do
  @databases = Set.new
  @users = Set.new
end

Then(/^I should see "(.*?)"$/) do |text|
  expect(last_response).to match text
end

When(/^I send a GET request to "(.*?)"$/) do |path|
  get path
end

When(/^I create a service instance with :instance_id "(.*?)"$/) do |instance_id|
  path = "/v2/service_instances/#{instance_id}"

  postgresql_service = double
  expect(PostgresHelper).to receive(:new).and_return(postgresql_service)

  if @databases.nil?
    expect(postgresql_service).to receive(:create_database).and_raise(ServerNotReachableError)
  elsif @databases.member? instance_id
    expect(postgresql_service).to receive(:create_database).and_raise(DatabaseAlreadyExistsError)
  else
    @databases << instance_id
    expect(postgresql_service).to receive(:create_database).and_return(path)
  end

  put path
end

When(/^I bind app with :binding_id "(.*?)" to a service_instance with :instance_id "(.*?)"$/) do |binding_id, instance_id|
  path = "/v2/service_instances/#{instance_id}/service_bindings/#{binding_id}"

  postgresql_service = double
  expect(PostgresHelper).to receive(:new).and_return(postgresql_service)

  if @users.nil?
    expect(postgresql_service).to receive(:create_user).and_raise(ServerNotReachableError)
  elsif @users.member? binding_id
    expect(postgresql_service).to receive(:create_user).and_raise(UserAlreadyExistsError)
  elsif ! @databases.member? instance_id
    expect(postgresql_service).to receive(:create_user).and_raise(DatabaseDoesNotExistError)
  else
    @users << binding_id
    expect(postgresql_service).to receive(:create_user).and_return(path)
  end

  put path
end

When(/^I unbind app with :binding_id "(.*?)" and :instance_id "(.*?)"$/) do |binding_id, instance_id|
  path = "v2/service_instances/#{instance_id}/service_bindings/#{binding_id}"
  postgresql_service = double
  expect(PostgresHelper).to receive(:new).and_return(postgresql_service)

  if @users.nil?
    expect(postgresql_service).to receive(:delete_user).and_raise(ServerNotReachableError)
  elsif ! @users.member? binding_id
    expect(postgresql_service).to receive(:delete_user).and_raise(UserDoesNotExistError)
  else
    @users.delete binding_id
    expect(postgresql_service).to receive(:delete_user)
  end

  delete path
end

When(/^I un\-provision a service instance with :instance_id "(.*?)"$/) do |instance_id|
  path = "/v2/service_instances/#{instance_id}"
  postgresql_service = double
  expect(PostgresHelper).to receive(:new).and_return(postgresql_service)

  if @databases.nil?
    expect(postgresql_service).to receive(:delete_database).and_raise(ServerNotReachableError)
  elsif ! @databases.member? instance_id
    expect(postgresql_service).to receive(:delete_database).and_raise(DatabaseDoesNotExistError)
  else
    expect(postgresql_service).to receive(:delete_database)
  end
  delete path
end

When(/^the server is not reachable$/) do
  @databases = nil
  @users = nil
end

Then /^the response status should be "([^"]*)"$/ do |status|
  expect(last_response.status).to eq status.to_i
end
