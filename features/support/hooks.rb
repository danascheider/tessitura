Before do |scenario|
  FactoryGirl.create(:admin, id: 1, email: 'admin@example.com', username: 'abc123', password: 'abcde12345')
  FactoryGirl.create(:user, id: 2, email: 'user2@example.com', username: 'bcd234', password: 'bcdef23456')
  FactoryGirl.create(:user, id: 3, email: 'user3@example.com', username: 'cde345', password: 'cdefg34567')
end