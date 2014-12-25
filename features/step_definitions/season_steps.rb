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