When(/^the client requests GET \/(.*)$/) do |path|
  get(path)
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