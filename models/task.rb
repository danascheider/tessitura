class Task < Sequel::Model
  include JSON
  many_to_one :task_list

  def before_validation
    super
    self.owner_id ||= self.task_list.try(:user_id)
    self.status ||= 'new'
    self.priority ||= 'normal'
  end

  def self.complete
    Task.where(status: 'complete')
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

  def to_hash
    {
      id: self.id,
      task_list_id: self.task_list_id,
      owner_id: self.owner_id,
      title: self.title,
      deadline: self.deadline,
      priority: self.priority,
      status: self.status,
      description: self.description,
      created_at: self.created_at,
    }.reject {|k,v| [nil, false, [], {}, ''].include? v }
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
    validates_presence [:title, :task_list_id]
    validates_includes ['new', 'in_progress', 'blocking', 'complete'], :status
    validates_includes ['urgent', 'high', 'normal', 'low', 'not_important'], :priority
    validates_unique   :position
  end
end