Then(/^the JSON response should include all the (\d+)(?:[a-z]{2}) user's tasks$/) do |id|
  expect(last_response.body).to eql User[id].tasks.to_json
end

Then(/^the JSON response should include the (\d+)(?:[a-z]{2}) user's incomplete tasks$/) do |id|
  expect(last_response.body).to eql User[id].tasks.where_not(:status, 'Complete').to_json
end

Then(/^the JSON response should include all the (\w+)s$/) do |model|
  expect(last_response.body).to eql eval(model.capitalize).all.to_json
end

Then(/^the JSON response should include all (\d+)(?:[a-z]{2}) organization's programs$/) do |id|
  expect(last_response.body).to eql Organization[id].programs.to_json
end

Then(/^the JSON response should include (?:only )?the (\d+)(?:[a-z]{2}) task$/) do |id|
  last_response.body.should === Task[id].to_json
end

Then(/^the JSON response should include the (\d+)(?:[a-z]{2}) user's profile information$/) do |id|
  expect(last_response.body).to eql User[id].to_json
end

Then(/^the JSON response should include the new program's data$/) do 
  expect(last_response.body).to eql Program.last.to_json
end

Then(/^the JSON response should include the program's profile information$/) do
  expect(last_response.body).to eql @program.to_json
end

Then(/^the JSON response should include the (\d+)(?:[a-z]{2}) season's data$/) do |id|
  expect(last_response.body).to eql Season[id].to_json
end

Then(/^the JSON response should include the program's fresh seasons$/) do
  seasons = Season.where(program_id: @program.id).exclude(stale: true)
  expect(last_response.body).to eql seasons.to_json
end

Then(/^the JSON response should include the organization's profile information$/) do
  expect(last_response.body).to eql @organization.to_json
end

Then(/^the response should not include any data$/) do 
  ok_values = [nil, '', 'null', false, "Authorization Required\n"]
  expect(ok_values).to include last_response.body
end

Then(/^the response should not include the other programs$/) do
  other_programs = Program.exclude(organization_id: @organization.id)
  other_programs.each {|p| expect(parse_json(last_response.body)).not_to include p.to_h }
end

Then(/^the response should not include the program's stale seasons$/) do
  stale = @program.seasons.where_not(:stale, true)
  expect(parse_json(last_response.body)).not_to be_superset_of(stale)
end

Then(/^the response should include an empty JSON object$/) do 
  expect(last_response.body).to eql([].to_json)
end

Then(/^the response should indicate the (?:.*) was (not )?saved successfully$/) do |negation|
  expect(last_response.status).to eql negation ? 422 : 201
end

Then(/^the response should indicate the (?:.*) was updated successfully$/) do
  expect(last_response.status).to eql 200
end

Then(/^the response should indicate the (?:.*) were( not)? saved successfully$/) do |neg|
  expect(last_response.status).to eql (neg ? 422 : 200)
end

Then(/^the response should indicate the (?:.*) was not updated successfully$/) do
  expect(last_response.status).to eql 422
end

Then(/^the response should indicate the request was unauthorized$/) do
  expect(last_response.status).to eql 401
end

Then(/^the response should return status (\d{3})$/) do |status|
  expect(last_response.status).to eql status
end

Then(/^the response should indicate the (?:.*) was deleted successfully$/) do
  expect(last_response.status).to eql (204)
end

Then(/^the response should indicate the (?:.*) was not found$/) do
  expect(last_response.status).to eql 404
end