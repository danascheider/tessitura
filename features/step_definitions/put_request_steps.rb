# Updating Users
# ==============
When(/^the client submits a PUT request to \/users\/(\d+) with no credentials and:$/) do |id, string|
  data = URI::encode_www_form(JSON.parse(string))
  @user = User[id]
  make_request('PUT', "/users/#{id}", data)
end

When(/^the client submits a PUT request to \/users\/(\d+) with the (\d+)(?:[a-z]{2}) user's credentials and:$/) do |path_id, user_id, string|
  data = URI::encode_www_form(JSON.parse(string))
  @user, @current = User[path_id], User[user_id]
  authorize_with @current
  make_request('PUT', "/users/#{path_id}", data)
end

# Updating Tasks
# ==============
When(/^the client submits a PUT request to \/tasks\/(\d+) with the (\d+)(?:[a-z]{2}) user's credentials and:$/) do |task_id, uid, string|
  data = URI::encode_www_form(JSON.parse(string))
  @task = Task[task_id]
  @current = User[uid]
  authorize_with @current
  make_request('PUT', "/tasks/#{task_id}", data)
end

When(/^the client submits a PUT request to \/tasks\/(\d+) with no credentials and:$/) do |id, string|
  data = URI::encode_www_form(JSON.parse(string))
  @task = Task[id]
  make_request('PUT', "/tasks/#{id}", data)
end
