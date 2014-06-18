class Task < ActiveRecord::Base
  validates :title, presence: true
  before_save :set_complete
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

  private
    def set_complete
      self.complete = false
    end
end
