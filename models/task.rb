class Task < ActiveRecord::Base

  belongs_to :task_list, foreign_key: :task_list_id
  acts_as_list scope: :task_list

  STATUS_OPTIONS = ['new', 'in_progress', 'blocking', 'complete']

  scope :complete, -> { where(status: 'complete') }
  scope :incomplete, -> { where.not(status: 'complete') }

  validates :title, presence: true, exclusion: { in: %w(nil null)}
  validates :status, inclusion: { in: STATUS_OPTIONS }
  before_save :set_complete

  def self.create!(opts)
    position ||= opts[:status] == 'complete' ? self.get_position_on_create_complete : 1
    super.insert_at(position)
  end

  def update!(opts)
    opts[:position] ||= get_position_on_update(opts)
    super
  end

  def complete?
    self.status == complete 
  end

  def incomplete?
    self.status != complete
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

  def self.first_complete
    self.complete.pluck(:position).sort[0] || Task.count
  end

  private
    def self.get_position_on_create_complete
      Task.complete.count ? Task.count - Task.complete.count + 1 : Task.count + 1
    end

    def get_position_on_update(opts)
      newly_complete?(opts) ? Task.count : (newly_incomplete?(opts) ? 1 : self.position)
    end

    def newly_complete?(opts)
      opts[:status] == 'complete' && self.status != 'complete'
    end

    def newly_incomplete?(opts)
      self.status == 'complete' && opts[:status] != 'complete'
    end

    def set_complete
      true if self.complete ||= false
    end
end