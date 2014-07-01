# REQUEST STEPS
# =============

When(/^the client requests GET \/(.*)$/) do |path|
  get(path)
end

When(/^the client submits a POST request to \/(.*) with:$/) do |path, string|
  # @task_count variable is used in task_steps.rb
  @task_count = Task.count
  key_value = string.gsub(/[{}']/, '').strip.split(':')
  post path, { key_value[0] => key_value[1] }.to_json, 'CONTENT_TYPE' => 'application/json'
end

When(/^the client submits a PUT request to \/tasks\/(\d+) with:$/) do |id, string|
  path = "/tasks/#{id}"

  # @task instance variable is used in task_steps.rb
  @task = Task.find(id.to_i)
  key_value = string.gsub(/[{}']/, '').strip.split(':')
  put path, { key_value[0] => key_value[1] }.to_json, 'CONTENT_TYPE' => 'application/json'
end

When(/^the client sends a DELETE request to \/tasks\/(\d+)$/) do |id|
  path = "/tasks/#{id}"
  delete path
end

# RESPONSE STEPS
# ==============

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
  expect(last_response.status).to eql negation ? 422 : 201
end

Then(/^the response should indicate the (.*) was (not )?updated successfully$/) do |resource, negation|
  expect(last_response.status).to eql negation ? 422 : 200
end

Then(/^the response should return status (\d{3})$/) do |status|
  expect(last_response.status).to eql 404
end

Then(/^the response should indicate the (.*) was deleted successfully$/) do |resource|
  expect(last_response.status).to eql 204
end