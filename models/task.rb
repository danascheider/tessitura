class Task < Sequel::Model
  include JSON
  many_to_one :task_list

  STATUS_OPTIONS   = [ 'New', 'In Progress', 'Blocking', 'Complete' ]
  PRIORITY_OPTIONS = [ 'Urgent', 'High', 'Normal', 'Low', 'Not Important' ]

  def before_validation
    super
    self.owner_id ||= self.task_list.user_id rescue false
    self.status   = 'New' unless self.status.in? STATUS_OPTIONS
    self.priority = 'Normal' unless self.priority.in? PRIORITY_OPTIONS
  end

  def self.complete
    Task.where(status: 'Complete')
  end

  def self.incomplete
    Task.exclude(status: 'Complete')
  end

  def to_hash
    hash = {
      id: self.id,
      task_list_id: self.task_list_id,
      owner_id: self.owner_id,
      title: self.title,
      deadline: self.deadline,
      priority: self.priority,
      status: self.status,
      description: self.description,
      backlog: self.backlog,
      created_at: self.created_at,
    }.reject {|key, value| value.blank? }

    hash
  end

  def to_json(options={})
    self.to_hash.to_json
  end

  def user
    self.task_list.user
  end
  alias_method :owner, :user

  def validate
    super
    validates_presence [:title, :task_list_id, :owner_id]
    validates_includes STATUS_OPTIONS, :status
    validates_includes PRIORITY_OPTIONS, :priority
  end
end