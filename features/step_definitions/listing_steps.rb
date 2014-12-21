When(/^the client submits a POST request to \/listings with valid attributes$/) do 
  @season = FactoryGirl.create(:season)
  @attributes = {
    title: 'Super Awesome Young Artist Program',
    season_id: @season.id
  }

  post '/listings', @attributes.to_json, 'CONTENT-TYPE' => 'application/json'
end

Then(/^a new listing should be created with the same attributes$/) do 
  @attributes.each do |key, val|
    expect(Listing.last.send(key)).to eql val
  end
end