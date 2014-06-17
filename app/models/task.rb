class Task < ActiveRecord::Base
  validates :title, presence: true
  scope :complete, -> { where(complete: true) }
  scope :incomplete, -> { where(complete: false) }

  def complete?
    self.complete
  end

  def incomplete?
    true unless self.complete
  end

  def mark_complete
    self.complete = true
  end
  
  # def to_partial_path
  #   'shared/task'
  # end
end
