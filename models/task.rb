class Task < ActiveRecord::Base
  validates :title, presence: true
  before_save :set_complete

  def incomplete?
    !self.complete
  end

  def to_hash
    { id: self.id,
      title: self.title, 
      complete: self.complete, 
      created_at: self.created_at,
      updated_at: self.updated_at
    }
  end

  private
    def set_complete
      true if self.complete ||= false
    end
end