class Task < ActiveRecord::Base
  scope :complete, -> { where(complete: true)}
  scope :incomplete, -> {where(complete: false)}

  def complete?
    self.complete
  end

  def incomplete?
    !self.complete
  end

  def to_hash
    {
      id:         self.id,
      title:      self.title,
      complete:   self.complete,
      created_at: self.created_at,
      updated_at: self.updated_at
    }
  end
end