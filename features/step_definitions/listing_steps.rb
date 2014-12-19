When(/^the client submits a POST request to \/listings with valid attributes$/) do 
  @attributes = {
    title: 'Super Awesome Young Artist Program',
    type:  'Young Artist Program',
    web_site: 'http://www.superawesomeyap.com',
    country: 'USA',
    region: 'New York',
    city: 'New York City',
    program_start_date: DateTime.new(2015, 7, 3),
    program_end_date: DateTime.new(2015, 8, 1),
    max_age: 35
  }

  post '/listings', @attributes.to_json, 'CONTENT-TYPE' => 'application/json'
end

Then(/^a new listing should be created with the same attributes$/) do 
  @attributes.each do |key, val|
    expect(Listing.last.send(key)).to eql val
  end
end