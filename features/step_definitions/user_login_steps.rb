Then /^there should be a link to log in$/ do 
  page.should have_css("a#login")
end

Then /^the '(.*)' link should take me to the (.*) page$/ do |link_text, page|
  click_link(link_text)
  current_path.should == login_path
end