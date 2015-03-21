Then(/^I should see "(.*?)"$/) do |text|
  expect(last_response).to match text
end

When /^I send (GET|POST|PUT|DELETE) request (?:for|to) "([^"]*)"(?: with the following:)?$/ do |*args|
  request_type = args.shift
  path = args.shift
  input = args.shift
  request_opts = {method: request_type.downcase.to_sym}
  unless input.nil?
    if input.class == Cucumber::Ast::Table
      request_opts[:params] = input.rows_hash
    else
      request_opts[:input] = input
    end
  end

  z = path.clone
  request_opts[:params].each_pair do |k, v|
    x = path =~ /:#{Regexp.quote(k)}/
    y = x + k.length
    z[x..y] = v
  end

  @req = "#{request_type.downcase} '#{z}'"
end

And(/I dont get any errors/) do
    postgresql_service = double
    expect(PostgresHelper).to receive(:new).with({"host"=>"localhost",
                                               "username"=>"admin",
                                               "password"=>"admin",
                                               "port"=>0}).and_return(postgresql_service)
    expect(postgresql_service).to receive(:create_database).with('d1').and_return('http://127.0.0.1:5432/databases/mydb')
    eval @req
end

When(/^it raises "(.*?)"$/) do |error|
  postgresql_service = double
  expect(PostgresHelper).to receive(:new).with({"host"=>"localhost",
                                               "username"=>"admin",
                                               "password"=>"admin",
                                               "port"=>0}).and_return(postgresql_service)

  expect(postgresql_service).to receive(:create_database).with('d1').and_raise(Kernel.const_get error)

  eval @req
end
