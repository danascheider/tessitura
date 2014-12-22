Then(/^a new organization should be created$/) do
  expect(Organization.count).to eql(@count + 1)
end

Then(/^no new organization should be created$/) do
  expect(Organization.count).to eql @count
end

Then(/^the new organization should be called "(.*?)"$/) do |arg1|
  expect(Organization.last.name).to eql arg1
end

Then(/^the response body should include the new organization's ID$/) do
  expect(parse_json(last_response.body)['id']).to eql Organization.last.id
end

Then(/^the response should indicate the organization was not created successfully$/) do
  expect(last_response.status).to eql 422
end