class Task < ActiveRecord::Base
  validates :title, presence: true
  
  def complete?
    self.complete
  end
end
