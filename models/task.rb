class Task < ActiveRecord::Base
  scope :complete, -> { where(complete: true) }
  scope :incomplete, -> { where(complete: false) }
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

  def self.max_index
    self.pluck(:index).sort[-1]
  end

  def self.update_indices(min, max, amount=1)
    Task.all.each {|task| task.increment!(:index, amount) if task.index.between?(min, max)}
  end

  private
    def set_complete
      true if self.complete ||= false
    end

    def set_index
      self.index ||= 1
    end
end