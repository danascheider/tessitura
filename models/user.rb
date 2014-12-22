class User < Sequel::Model(:users)
  one_to_many :task_lists
  many_to_many :programs, left_key: :user_id, right_key: :program_id, join_table: :programs_users

  # The `#owner_id` method returns the user's `:id` attribute, since the 
  # user table has no foreign keys. This method allows all of Canto's 
  # resources to be treated more uniformly, reducing the need for 
  # code duplication.

  alias_method :owner_id, :id

  # The `#admin?` method aliases the `#admin` attribute - a boolean returning
  # true if the user is an admin.

  def admin?
    admin
  end

  # The `User.admin` scope returns all users who are admins

  def self.admin 
    User.where(admin: true)
  end

  def add_task_list(list)
    raise NoMethodError, '#add_task_list has been overridden in the User model (see documentation)'
  end

  # The `before_destroy` hook prevents the last admin user from being deleted.
  # It also deletes all of the user's task lists recursively, preventing 
  # foreign key errors from the database.

  def before_destroy
    return false if admin? && User.admin.count == 1
    remove_all_task_lists
  end

  # Users own tasks through task lists. If a user who doesn't have any task lists
  # creates a task, then a new task list is created for that task. If the user does
  # have task lists and does not specify one when creating a task, the task is
  # added to the user's first task list.

  def default_task_list
    task_lists.length > 0 ? task_lists.first : TaskList.create(user: self)
  end
  
  # This method is added automatically by Sequel and has been overridden
  # here so as not to interfere with the foreign key constraint on the table

  def remove_all_task_lists
    task_lists.each(&:destroy)
    reload # to prevent lists from being cached
  end

  # This method is added automatically by Sequel and has been overridden
  # here so as not to interfere with the foreign key constraint on the table

  def remove_task_list(list)
    list.destroy
    reload # to prevent list from being cached
  end

  # The `#tasks` method returns an array of all the tasks the user owns,
  # regardless of which task list they belong to.

  def tasks
    (task_lists.map {|list| list.tasks.flatten }).flatten
  end

  # The `#to_hash` or `:to_h` method returns a hash of all the user's non-empty
  # attributes, including an array of the IDs of any task lists belonging to 
  # the user. Attributes that are empty or nil are not included in the hash,
  # so not all columns will be present in every hash.
  #
  # For security reasons, the password is not returned in the hash.

  def to_hash
    super.reject {|k,v| v.blank? || k === :password }
  end

  alias_method :to_h, :to_hash

  # Override the `#to_json` method so the JSON object is created from the 
  # hash of the user's attributes instead of from the user object itself

  def to_json()
    to_h.to_json
  end

  # Users must provide a valid username, password, and e-mail address. The
  # username and e-mail must be unique. Username and password must each be
  # 8 characters long or longer.
  #
  # FIX: Might be good to allow shorter usernames. Think about it.

  def validate
    super
    validates_presence [:username, :password, :email]
    validates_unique(:username, :email)
    validates_format /@/, :email, message: 'is not a valid e-mail address'
    validates_min_length 8, :username
    validates_min_length 8, :password
  end
end
