When(/^the client requests GET \/(.*)$/) do |path|
  get(path)
end

Then(/^the JSON response should include all the tasks$/) do 
  last_response.body.should === Task.all.to_json
end