Before do 
  if ENV['TRAVIS']
    system 'rake travis:prepare'
  else
    system 'rake db:test:prepare > /dev/null 2>&1'
  end
end