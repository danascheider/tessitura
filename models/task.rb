class Task < Sequel::Model
  many_to_one :task_list

  # Possible values for task status and priority, enforced on validation

  STATUS_OPTIONS   = [ 'New', 'In Progress', 'Blocking', 'Complete' ]
  PRIORITY_OPTIONS = [ 'Urgent', 'High', 'Normal', 'Low', 'Not Important' ]

  # By default, tasks are created at the top of the list

  def before_create
    self.position ||= 1
    super 
  end

  def before_update
    if self.modified?(:status) && self.status === 'Complete' && !self.modified?(:position)
      self.position = Task.incomplete.where(owner_id: self.owner_id).order_by(:position).last.position
    end

    super
  end

  # When a task has been saved, either on create or on update, the `after_save`
  # hook adjusts the positions of the other tasks belonging to the same user 
  # such that there are no gaps or duplicate indices on the list

  def after_save
    super
    Task.adjust_positions(self)
  end

  # When a task is destroyed, the rest of the tasks with the same owner should
  # have their list position incremented such that there are no gaps in the 
  # indices. 

  def after_destroy
    super
    Task.where('position > ?', self.position).each {|t| t.this.update(position: t.position - 1 )}
  end

  # The `before_validation` hook assigns automatic values before a task is 
  # validated on creation or update:
  # * Ensures that a task list has been specified
  # * Assigns the `:owner_id` attribute based on the owner of the specified task list
  # * Sets `:status` to a default value of 'New' unless a valid status is given
  # * Sets `:priority` to a default value of 'Normal' unless a valid priority level
  #   is given

  def before_validation
    super
    self.owner_id ||= self.task_list.user_id rescue false
    self.status   = 'New' unless self.status.in? STATUS_OPTIONS
    self.priority = 'Normal' unless self.priority.in? PRIORITY_OPTIONS
  end

  # The `Task.complete` scope returns all tasks whose status is 'Complete'

  def self.complete
    Task.where(status: 'Complete')
  end

  # The `Task.incomplete` scope includes all tasks with a status other 
  # than 'Complete'. 

  def self.incomplete
    Task.exclude(status: 'Complete')
  end

  # The `#to_hash` or `#to_h` method returns a hash of all of the task's 
  # non-empty attributes. Keys for blank attributes are removed from the
  # hash, so not all columns will necessarily be represented in the hash.

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

  # Overwrites the default `#to_json` method to return a JSON object based
  # on the task's attribute hash

  def to_json(options={})
    self.to_hash.to_json
  end

  # The `user` method returns the user who ultimately owns the task. Since
  # users own tasks only through the `:task_lists` table, this provides
  # a direct reference to the user object that owns the list the given
  # task is on.

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
      positions = (scoped_tasks = Task.where(owner_id: changed.owner_id)).map(&:position).sort!

      values = Task.return_values(positions)

      return true if values === []

      # Tasks iterate through tasks, updating the positions. Note the use
      # of `t.this.update(args)` - this carries out the `update` action on
      # a Sequel::Dataset representation of the task model, thus bypassing
      # any hooks otherwise triggered by an update.

      scoped_tasks.where([[:position, values[0]..values[1]]]).each do |t|
        t.this.update(position: t.position + values[2]) unless t === changed
      end
    end

    def self.return_values(positions) 
      dup, gap = Task.get_dup_and_gap(positions)[0], Task.get_dup_and_gap(positions)[1]

      # No `dup` and no `gap` indicates no positions have been changed.
      # (A `gap` with no `dup` indicates a task was destroyed, in which case
      # that will be taken care of in the `after_destroy` hook.)

      return [] unless dup

      # This method returns an array with three elements: A minimum
      # value, a maximum value, and an incrementor. The three arrangements
      # of this array reflect three possible situations:
      #   1. A task has been moved towards the top of the list (its 
      #      position number has gotten lower)
      #   2. A task has been moved towards the bottom of the list
      #      (its position number has gotten higher)
      #   3. A task has been added to the list

      return [dup, positions.count, 1] unless gap
      return [dup, gap].sort << (gap < dup ? -1 : 1)
    end

    # The `Task.get_dup_and_gap` method takes a sorted list of indices as 
    # a parameter and returns the value of any duplicates, as well as any
    # indices that are missing between the lowest and highest indices on 
    # the list.

    def self.get_dup_and_gap(positions)

      # When a new task has been added or the position of a task has been
      # changed, one or both of two things will happen to the sequence of 
      # positions:
      #   1. A duplicate position will appear at the position the 
      #      task was created at or moved to
      #   2. A gap will appear at the position the task was removed from
      #
      # `dup` and `gap` represent the duplicate position number and the 
      # missing position number, respectively
      
      dup = positions.find {|number| positions.count(number) > 1 }
      gap = (1..positions.last).find {|number| positions.count(number) === 0 }
      [dup, gap]
    end
end