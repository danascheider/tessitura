When(/^the client requests GET \/(.*)$/) do |path|
  get(path)
end

Then(/^the response should be JSON:$/) do |string|
  pending # express the regexp above with the code you wish you had
end