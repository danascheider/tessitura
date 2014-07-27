class TaskList < ActiveRecord::Base
  belongs_to :user
  has_many :tasks, -> { order("position ASC") }
end