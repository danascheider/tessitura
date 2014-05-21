class TodoItem < ActiveRecord::Base
  belongs_to :user
  before_save :ensure_status
  has_many :categorizations, foreign_key: :todo_id
  has_many :categories, through: :categorizations
  validates :title, presence: true
  scope :incomplete, -> { where.not(status: 'Complete')}

  def ensure_status
    self.status ||= 'New'
  end
end
