class Task < ActiveRecord::Base
  include RankedModel

  belongs_to :task_list, foreign_key: :task_list_id
  ranks :position, with_same: :task_list_id

  STATUS_OPTIONS = ['new', 'in_progress', 'blocking', 'complete']
  PRIORITY_OPTIONS = ['urgent', 'high', 'normal', 'low', 'not_important']

  # Validations and Callbacks
  scope :complete, -> { where(status: 'complete') }
  scope :incomplete, -> { where.not(status: 'complete') }

  validates :task_list, presence: true
  validates :title, presence: true, exclusion: { in: %w(nil null)}
  validates :status, 
            inclusion: { in: STATUS_OPTIONS,
                         message: "Invalid status: Status must be one of: #{STATUS_OPTIONS}" }
  validates :priority, 
            inclusion: { in: PRIORITY_OPTIONS,
                        message: "Invalid priority level: Priority must be one of #{PRIORITY_OPTIONS}" }

  before_create :set_owner_id
  before_save   :set_position

  # Public Class Methods
  # ====================
  def self.create!(opts)
    super(opts)
  end

  def self.first_complete
    self.complete.rank(:position).first || self.count - 1
  end

  # Public Instance Methods
  # =======================

  def update!(opts)
    opts[:position] ||= get_position_on_update(opts) if status_changed?(opts)
    super
  end

  def complete?
    self.status == 'complete' 
  end

  def incomplete?
    self.status != 'complete'
  end

  def owner_id
    self.user.id
  end

  def siblings
    Task.where(task_list_id: self.owner.task_lists.pluck(:id)).where.not(id: self.id)
  end

  def to_hash
    { id: self.id,
      position: self.position,
      title: self.title, 
      priority: self.priority,
      status: self.status, 
      deadline: self.deadline,
      description: self.description,
      owner_id: self.user.id,
      task_list_id: self.task_list.id,
      created_at: self.created_at,
      updated_at: self.updated_at
    }.delete_if {|key, value| value.nil? }
  end

  def user
    self.task_list.user
  end

  alias_method :owner, :user

  private

    # Private Instance Methods
    # ========================
    def set_position
      self.position = self.complete? ? self.siblings.first_complete : 0
    end

    def get_position_on_update(opts)
      opts[:status] == 'complete' ? self.owner.tasks.count : 0
    end

    def set_owner_id
      self.owner_id = TaskList.find(self.task_list_id).user.id
    end

    def status_changed?(opts)
      opts[:status] && opts[:status] != self.status
    end
end