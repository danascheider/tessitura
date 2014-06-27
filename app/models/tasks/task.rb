class Task < ActiveRecord::Base
  scope :complete, -> { where(complete: true)}
  scope :incomplete, -> {where(complete: false)}
  
  def incomplete?
    !self.complete
  end
end