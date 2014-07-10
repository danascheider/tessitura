class Task < ActiveRecord::Base
  scope :complete, -> { where(complete: true) }
  scope :incomplete, -> { where(complete: false) }
  validates :title, presence: true, exclusion: { in: %w(nil null)}
  before_save :set_complete

  def incomplete?
    !self.complete
  end

  def to_hash
    { id: self.id,
      position: self.position,
      title: self.title, 
      complete: self.complete, 
      created_at: self.created_at,
      updated_at: self.updated_at
    }
  end

  def self.last_updated 
    self.order(:updated_at)[-1]
  end

  private
    def set_complete
      true if self.complete ||= false
    end
end