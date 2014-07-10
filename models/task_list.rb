class TaskList < ActiveRecord::Base
  has_many :tasks, -> { order("position ASC") }
end