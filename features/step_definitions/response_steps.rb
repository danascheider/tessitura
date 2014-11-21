Then(/^the JSON response should include all the (\d+)(?:[a-z]{2}) user's tasks$/) do |id|
  expect(last_response.body).to eql User[id].tasks.to_json
end

Then(/^the JSON response should include the (\d+)(?:[a-z]{2}) user's incomplete tasks$/) do |id|
  expect(last_response.body).to eql User[id].tasks.where_not(:status, 'Complete').to_json
end

Then(/^the JSON response should include all the users$/) do 
  expect(last_response.body).to eql User.all.to_json
end

Then(/^the JSON response should include (?:only )?the (\d+)(?:[a-z]{2}) task$/) do |id|
  last_response.body.should === Task[id].to_json
end

Then(/^the JSON response should include the (\d+)(?:[a-z]{2}) user's profile information$/) do |id|
  expect(last_response.body).to eql User[id].to_json
end

Then(/^the response should not include any data$/) do 
  ok_values = [nil, '', 'null', false, "Authorization Required\n"]
  expect(ok_values).to include last_response.body
end

Then(/^the response should indicate the (?:.*) was (not )?saved successfully$/) do |negation|
  expect(last_response.status).to eql negation ? 422 : 201
end

Then(/^the response should indicate the (?:.*)(not )?updated successfully$/) do |negation|
  expect(last_response.status).to eql negation ? 422 : 200
end

Then(/^the response should indicate the request was unauthorized$/) do
  expect(last_response.status).to eql 401
end

Then(/^the response should (not )?return status (\d{3})$/) do |status, neg|
  if neg 
    expect(last_response.status).not_to eql status
  else
    expect(last_response.status).to eql status
  end
end

Then(/^the response should indicate the (?:.*) was deleted successfully$/) do
  expect(last_response.status).to eql (204)
end

Then(/^the response should indicate the (?:.*) was not found$/) do
  expect(last_response.status).to eql 404
end