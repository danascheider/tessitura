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

  def after_destroy
    super
    Task.where('position > ?', self.position).each {|t| t.this.update(position: t.position - 1 )}
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
      positions = ((scoped_tasks = Task.where(owner_id: changed.owner_id)).map {|t| t.position }).sort!

      # When a new task has been added or the position of a task has been
      # changed, one or both of two things will happen to the sequence of 
      # positions:
      #   1. A duplicate position will appear at the position the 
      #      task was created at or moved to
      #   2. A gap will appear at the position the task was removed from
      #
      # `dup` and `gap` represent the duplicate position number and the 
      # missing position number, respectively
      
      dup = positions.find {|num| positions.count(num) > 1 }
      gap = (1..positions.last).find {|num| positions.count(num) === 0 }

      # The 3 cases handled here signify, respectively, that:
      #   1. A task has been moved towards the top of the list (its 
      #      position number has gotten lower)
      #   2. A task has been moved towards the bottom of the list
      #      (its position number has gotten higher)
      #   3. A task has been added to the list
      #
      # No `dup` and no `gap` indicates no positions have been changed.
      # A `gap` with no `dup` indicates a task was destroyed, in which case
      # that will be taken care of in the `after_destroy` hook.

      case
      when dup && gap && dup < gap
        puts "case 1" if Task.count === 10
        scoped_tasks.where([[:position, dup..gap]]).each do |t|
          t.this.update(position: t.position + 1) unless t === changed 
        end
      when dup && gap && dup > gap
        puts "case 2" if Task.count === 10
        scoped_tasks.where([[:position, gap..dup]]).each do |t|
          t.this.update(position: t.position - 1) unless t === changed
        end
      when dup
        puts "case 3" if Task.count === 10
        scoped_tasks.where([[:position, dup..scoped_tasks.count]]).each do |t|
          t.this.update(position: t.position + 1) unless t === changed
        end
      end
    end
end