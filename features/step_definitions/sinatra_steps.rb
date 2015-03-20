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

  request_opts[:params].each_pair do |k, v|
    x = path =~ /:#{Regexp.quote(k)}/
    y = x + k.length
    path[x..y] = v
  end

  eval "#{request_type.downcase} '#{path}'"
end
