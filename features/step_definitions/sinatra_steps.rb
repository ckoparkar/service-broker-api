Before do
  @databases = Set.new
end

Then(/^I should see "(.*?)"$/) do |text|
  expect(last_response).to match text
end

When /^I send GET request (?:for|to) "([^"]*)"(?: with the following:)?$/ do |*args|
  request_type = args.shift
  path = args.shift
  input = args.shift
  request_opts = {method: request_type.downcase.to_sym}
  unless input.nil?
    if input.class == Cucumber::Ast::Table
      request_opts[:params] = input.rows_hash
    else
      request_opts[:params] = eval input
    end
  end
  request path
end

When /^I send (PUT|DELETE) request (?:for|to) "([^"]*)"(?: with the following:)?$/ do |*args|
  request_type = args.shift
  path = args.shift
  input = args.shift
  request_opts = {method: request_type.downcase.to_sym}
  unless input.nil?
    if input.class == Cucumber::Ast::Table
      request_opts[:params] = input.rows_hash
    else
      request_opts[:params] = eval input
    end
  end

  db = path.clone
  request_opts[:params].each_pair do |k, v|
    x = path =~ /:#{Regexp.quote(k)}/
    y = x + k.length
    db[x..y] = v
  end
  
  req = "#{request_type.downcase} '#{db}'"

  postgresql_service = double
  expect(PostgresHelper).to receive(:new).and_return(postgresql_service)

  case request_type
  when "PUT"
    if @databases.nil?
      expect(postgresql_service).to receive(:create_database).and_raise(ServerNotReachableError)
    elsif @databases.member? db
      expect(postgresql_service).to receive(:create_database).and_raise(DatabaseAlreadyExistsError)
    else
      @databases << db
      expect(postgresql_service).to receive(:create_database).and_return(db)
    end
  end
  eval req
end

When(/^the server is not reachable$/) do
  @databases = nil
end
