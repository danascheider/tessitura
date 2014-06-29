When(/^the client requests GET \/(.*)$/) do |path|
  get(path)
end

Then(/^the JSON response should include all the tasks$/) do 
  last_response.body.should === Task.all.to_json
end

Then(/^the JSON response should include only the first task$/) do
  last_response.body.should === Task.find(1).to_json
end