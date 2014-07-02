# TRANSFORMS
# ==========

Transform(/^{ '.*':'?.*'? }$/) do |object|
  object = object.to_s
  key_value = object.to_s.gsub(/[{}']/, '').strip.split(':')
  { key_value[0] => key_value[1] }.to_json
end

# REQUEST STEPS
# =============

When(/^the client submits a (.*) request to \/(\S+)$/) do |method, path|
  make_request(method, path)
end

When(/^the client submits a (.*) request to \/(.*) with:$/) do |method, path, string|
  # @task_count variable is used in task_steps.rb
  @task_count = Task.count
  @task = (id = (/\d+/.match(path)).to_s) > '' ? Task.find(id) : nil
  make_request(method, path, string)
end

# RESPONSE STEPS
# ==============

Then(/^the JSON response should include all the tasks$/) do 
  response_body.should === json_task(:all)
end

Then(/^the JSON response should (not )?include (?:only )?the (\d+)(?:[a-z]{2}) task$/) do |negation, id|
  if negation
    response_body.should_not include json_task(id)
  else 
    response_body.should === json_task(id)
  end
end

Then(/^the response should indicate the (.*) was (not )?saved successfully$/) do |resource, negation|
  expect(response_status).to eql negation ? 422 : 201
end

Then(/^the response should indicate the (.*) was (not )?updated successfully$/) do |resource, negation|
  expect(response_status).to eql negation ? 422 : 200
end

Then(/^the response should return status (\d{3})$/) do |status|
  expect(response_status).to eql status
end

Then(/^the response should indicate the (?:.*) was deleted successfully$/) do
  expect(response_status).to eql 204
end

Then(/^the response should indicate the (?:.*) was not found$/) do
  expect(response_status).to eql 404
end