class TaskList < ActiveRecord::Base
  belongs_to :user
  has_many :tasks, -> { order("position ASC") }, dependent: :destroy
  validates :user, presence: true

  def owner
    self.user
  end

  def to_a
    self.tasks.map {|task| task.to_hash }
  end
end