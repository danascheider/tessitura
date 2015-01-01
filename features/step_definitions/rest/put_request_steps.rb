# Updating Users
# ==============
When(/^the client submits a PUT request to \/users\/(\d+) with no credentials and:$/) do |id, string|
  @user = User[id]
  put "/users/#{id}", string, 'CONTENT_TYPE' => 'application/json'
end

When(/^the client submits a PUT request to \/users\/(\d+) with the (\d+)(?:[a-z]{2}) user's credentials and:$/) do |path_id, user_id, string|
  @user, @current = User[path_id], User[user_id]
  authorize_with @current
  put "/users/#{path_id}", string, 'CONTENT_TYPE' => 'application/json'
end

# Updating Tasks
# ==============
When(/^the client submits a PUT request to \/tasks\/(\d+) with the (\d+)(?:[a-z]{2}) user's credentials and:$/) do |task_id, uid, string|
  File.open('log/app.log', 'w+') do |file|
    Task.where(owner_id: 3).order(:position).each {|task| file.puts "#{task.to_h}\n"}
    file.puts "\n"
  end

  @task = Task[task_id]
  @current = User[uid]
  authorize_with @current
  put "/tasks/#{task_id}", string, 'CONTENT_TYPE' => 'application/json'
end

When(/^the client submits a PUT request to \/tasks\/(\d+) with no credentials and:$/) do |id, string|
  @task = Task[id]
  put "/tasks/#{id}", string, 'CONTENT_TYPE' => 'application/json'
end

When(/^the client submits a PUT request to \/users\/(\d+)\/tasks with the (\d+)(?:[a-z]{2}) user's credentials and:$/) do |uid1, uid2, string|
  @user, @current, @tasks = User[uid1], User[uid2], parse_json(string)
  authorize_with @current
  put "users/#{uid1}/tasks", string, 'CONTENT_TYPE' => 'application/json'
end

# Updating Organizations
# ======================

When(/^the client submits a PUT request to \/organizations\/(\d+) with (.*) credentials and:$/) do |id, type, string|
  @organization = Organization[id]
  authorize_with User[type === 'admin' ? 1 : 2] unless type === 'no'
  put "organizations/#{id}", string, 'CONTENT_TYPE' => 'application/json'
end

# Updating Programs
# =================
When(/^the client submits a PUT request to \/programs\/(\d+) with (admin|user|no) credentials and:$/) do |id, type, string|
  @program = Program[id]
  authorize_with User[type === 'admin' ? 1 : 2] unless type === 'no'
  put "/programs/#{id}", string, 'CONTENT_TYPE' => 'application/json'
end

# Updating Seasons
# ================
When(/^the client submits a PUT request to \/seasons\/(\d+) with (.*) credentials and:$/) do |id, type, string|
  @season = Season[id]
  authorize_with User[type === 'admin' ? 1 : 2] unless type === 'no'
  put "/seasons/#{id}", string, 'CONTENT_TYPE' => 'application/json'
end