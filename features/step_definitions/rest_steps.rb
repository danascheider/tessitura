When(/^the client requests GET \/(.*)$/) do |path|
  get(path)
end

When(/^the client submits a POST request to \/(.*) with:$/) do |path, string|
  @task_count = Task.count
  key_value = string.gsub(/[{}']/, '').strip.split(':')
  post path, { key_value[0] => key_value[1] }.to_json, 'CONTENT_TYPE' => 'application/json'
end

Then(/^the JSON response should include all the tasks$/) do 
  last_response.body.should === Task.all.to_json
end

Then(/^the JSON response should include only the (\d+)(.{2}) task$/) do |id, ordinal|
  last_response.body.should === Task.find(id).to_json
end

Then(/^the JSON response should not include the (\d+)(.{2}) task$/) do |id, ordinal|
  last_response.body.should_not include(Task.find(id).to_json)
end

Then(/^the response should indicate the (.*) was (not )?saved successfully$/) do |resource, negation|
  @response ||= last_response
  expect(@response.status).to eql negation ? 422 : 201
end