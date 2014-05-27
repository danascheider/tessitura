Then /^there should be a link to log in$/ do 
  page.should have_css("a#login")
end

Then /^the '(.*)' link should take me to the (.*) page$/ do |link_text, page|
  click_link(link_text)
  current_path.should == login_path
end

When /^I navigate to the login page$/ do 
  visit(login_path)
end

When /^I enter my username and password$/ do 
  fill_in(:username, with: @user.username)
  fill_in(:password, with: @user.password)
  click_button('Log In')
end