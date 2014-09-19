class Task < Sequel::Model
  many_to_one :task_list

  def before_create
    super
    self.owner_id = self.task_list.user_id
    self.status ||= 'new'
    self.priority ||= 'normal'
  end

  def self.complete
    DB[:tasks].where(status: 'complete')
  end

  def self.first_complete
    Task.complete.order(:position).first
  end

  def complete?
    self.status == 'complete'
  end

  def incomplete?
    self.status != 'complete'
  end

  def siblings
    self.task_list.tasks - [self]
  end

  def user
    self.task_list.user
  end
  alias_method :owner, :user

  def validate
    super
    validates_presence [:title, :task_list_id]
    validates_includes ['new', 'in_progress', 'blocking', 'complete'], :status
    validates_includes ['urgent', 'high', 'normal', 'low', 'not_important'], :priority
    validates_unique   :position
  end
end