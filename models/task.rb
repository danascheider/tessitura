class Task < Sequel::Model
  include JSON
  many_to_one :task_list

  # Possible values for task status and priority, enforced on validation

  STATUS_OPTIONS   = [ 'New', 'In Progress', 'Blocking', 'Complete' ]
  PRIORITY_OPTIONS = [ 'Urgent', 'High', 'Normal', 'Low', 'Not Important' ]

  def before_create
    self.position ||= 1
    super 
  end

  def after_save
    super
    Task.adjust_positions(self)
  end

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
      position: self.position,
      title: self.title,
      deadline: self.deadline,
      priority: self.priority,
      status: self.status,
      description: self.description,
      backlog: self.backlog,
      created_at: self.created_at,
    }.reject! {|key, value| value.blank? }
  end

  alias_method :to_h, :to_hash

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

  private

    # The Task.update_positions method uses `task.this` to carry out the 
    # #update action on a dataset consisting of the task. This is done to 
    # skip the `before_update`/`before_save` hook calling update_positions,
    # which would lead to infinite recursion.

    def self.adjust_positions(changed)
      positions = (scoped_tasks = Task.where(owner_id: changed.owner_id)).map {|t| t.position }
      positions.sort!
      # puts "INITIAL: #{positions}"

      # Whereas the #select method returns an array of values meeting the given 
      # criterion, the #find method returns the first value that meets the
      # criterion

      dup = positions.find {|num| positions.count(num) > 1 }
      gap = (1..positions.last).find {|num| positions.count(num) === 0 }
      # puts "  DUP: #{dup}"
      # puts "  GAP: #{gap}"

      case
      when dup && gap && dup < gap
        scoped_tasks.where([[:position, dup..gap]]).each do |t|
          t.this.update(position: t.position + 1) unless t === changed 
        end
      when dup
        scoped_tasks.where([[:position, dup..scoped_tasks.count]]).each do |t|
          t.this.update(position: t.position + 1) unless t === changed
        end
      end

      # puts "  FINAL: #{scoped_tasks.map {|t| t.position }}\n\n"
    end

    def self.update_positions(authoritative, old=nil)
      scoped_tasks = Task.where(owner_id: authoritative.owner_id)

      tasks.each do |task|
        task.this.update({position: task.position + 1}) unless task === authoritative
      end
    end
end