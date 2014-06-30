When(/^the client requests GET \/(.*)$/) do |path|
  get(path)
end

When(/^the client submits a POST request to \/(.*) with:$/) do |path, string|
  key_value = string.gsub(/[{}']/, '').strip.split(':')

  # This step fails if the response indicates an error. This is a problem when
  # the step is part of a scenario testing the app's behavior when an invalid
  # request is submitted. In order for this step to test ONLY the client's 
  # making the request - this being how Cucumber rolls - I am including a
  # rather unorthodox rescue, which I hope handles only this error. If you have
  # a better idea, gentle reader, I would love to hear it.

  begin
    post path, { key_value[0] => key_value[1] }.to_json, 'CONTENT_TYPE' => 'application/json'
  rescue ActiveRecord::RecordInvalid
    true
  end
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
  expect(last_response.status).to eql negation ? 422 : 201
end