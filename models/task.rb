class Task < ActiveRecord::Base
  validates :title, presence: true
  before_save :set_complete
  before_save :validate_title # See note

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

    # Cucumber tests failed when the title was set to 'nil' or 'null' (as strings)
    # RSpec test depended on validates. Go figure. This is inelegant but not a high
    # priority right now.
    
    def validate_title
      invalid = ([nil, 'nil', 'null'].include?(self.title) || !self.title)
      raise ActiveRecord::RecordInvalid.new(self) if invalid
    end
end