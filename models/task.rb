class Task < ActiveRecord::Base
  validates :title, presence: true, exclusion: { in: %w(nil null)}
  before_save :set_complete
  before_save :set_index, on: :create

  def incomplete?
    !self.complete
  end

  def to_hash
    { id: self.id,
      index: self.index,
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

    def set_index
      self.index ||= 1
    end
end