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