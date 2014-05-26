class TodoItem < ActiveRecord::Base
  belongs_to :user
  before_save :ensure_status
  validates :title, presence: true
  scope :incomplete, -> { where.not(status: 'Complete')}

  def ensure_status
    self.status ||= 'New'
  end

  def set_complete
    self.status = 'Complete'
  end
end
