Then(/^the JSON response should include all the (\d+)nd user's tasks$/) do |id|
  expect(response_body).to eql User[id].tasks.to_json
end

Then(/^the JSON response should include all the users$/) do 
  expect(response_body).to eql User.all.to_json
end

Then(/^the JSON response should include (?:only )?the (\d+)(?:[a-z]{2}) task$/) do |id|
  response_body.should === Task[id].to_json
end

Then(/^the JSON response should include the (\d+)(?:[a-z]{2}) user's profile information$/) do |id|
  expect(response_body).to eql User[id].to_json
end

Then(/^the response should not include any data$/) do 
  ok_values = [nil, '', 'null', false, "Authorization Required\n"]
  expect(ok_values).to include response_body
end

Then(/^the response should indicate the (?:.*) was (not )?saved successfully$/) do |negation|
  expect(response_status).to eql negation ? 422 : 201
end

Then(/^the response should indicate the (?:.*) was (not )?updated successfully$/) do |negation|
  expect(response_status).to eql negation ? 422 : 200
end

Then(/^the response should indicate the request was unauthorized$/) do
  expect(response_status).to eql 401
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