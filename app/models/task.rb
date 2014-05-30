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
end
