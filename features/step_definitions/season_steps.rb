Then(/^a new season should be created with the following attributes:$/) do |attributes|

  # Don't fucking touch this definition. It took me so long to make this thing work
  
  attributes.hashes.each do |hash|
    hash.symbolize_keys!.each do |k,v| 
      v = (v.try_rescue(:to_i) || v) unless v.match(/\d{4}\-\d{2}\-\d{2}/)
      expect(Season.last.send(k)).to eql v.try_rescue(:to_date) || v
    end
  end
end

Then(/^no new season should be created$/) do
  expect(Season.count).to eql @count
end