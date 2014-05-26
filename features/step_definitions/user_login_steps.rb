Then /^there should be a link to log in$/ do 
  page.should have_css("a#login")
end