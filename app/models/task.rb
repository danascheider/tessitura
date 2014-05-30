class Task < ActiveRecord::Base
  validates :title, presence: true
  scope :complete, -> { where(complete: true) }

  def complete?
    self.complete
  end
end
