Dir.glob("../models/*") {|file| require file }

Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin :timestamps

User.plugin :association_dependencies, task_lists: :destroy
TaskList.plugin :association_dependencies, tasks: :destroy