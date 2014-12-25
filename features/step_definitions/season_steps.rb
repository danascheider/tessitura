Given(/^there is no season with ID (\d+)$/) do |id|
  Season[id].try_rescue(:destroy)
end

Given(/^program (\d+) has only stale seasons$/) do |id|
  if Program[id] 
    if Program[id].seasons.length > 0
      Program[id].seasons.scope(:stale, false).each {|s| s.update(stale: true) }
    else
      FactoryGirl.create_list(:stale_season, 3, program_id: id.to_i)
    end
  else
    Program[id] === FactoryGirl.create(:program, id: id.to_i)
  end
end

Then(/^a new season should be created with the following attributes:$/) do |attributes|
  attributes.hashes.each do |hash|
    hash.symbolize_keys!.each do |k,v| 
      hash[k] = if v.match(/\d{4}\-\d{2}\-\d{2}/) then Date.strptime(v, '%Y-%m-%d')
      elsif v.match(/\d+/) then v.to_i
      else v; end
    end

    expect(hash).to be_subset_of(Season.last.to_h)
  end
end

Then(/^no new season should be created$/) do
  expect(Season.count).to eql @count
end

Then(/^the season should be deleted$/) do
  expect(Season[@season.id]).to be nil
end

Then(/^no season should be deleted$/) do 
  expect(Season.count).to eql @count
end

Then(/^season (\d+) should not be deleted$/) do |id|
  expect(Season[id]).not_to be nil
end

Then(/^the season should not be updated$/) do
  expect(@season.values).to eql @season.refresh.values
end

Then(/^the season's (.*) should be (.*)$/) do |attr, value|
  value = Date.strptime(value, '%Y-%m-%d') if value.match(/\d{4}\-\d{2}\-\d{2}/)
  expect(@season.refresh.send(attr.to_sym)).to eql value
end

Then(/^the season's (.*) should not be (.*)$/) do |attr, value|
  value = Date.strptime(value, '%Y-%m-%d') if value.match(/\d{4}\-\d{2}\-\d{2}/)
  expect(@season.refresh.send(attr.to_sym)).not_to eql value
end