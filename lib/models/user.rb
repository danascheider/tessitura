class User < Sequel::Model
  one_to_many :task_lists
  many_to_one :fach
  many_to_many :programs, left_key: :user_id, right_key: :program_id, join_table: :programs_users

  # The ++#owner_id++ method returns the user's ++:id++ attribute, since the 
  # user table has no foreign keys. This method allows all of Tessitura's 
  # resources to be treated more uniformly, reducing the need for 
  # code duplication.

  alias_method :owner_id, :id

  # The ++#admin?++ method aliases the ++#admin++ attribute - a boolean returning
  # true if the user is an admin.

  def admin?
    admin
  end

  # The ++User.admin++ scope returns all users who are admins

  def self.admin 
    User.where(admin: true)
  end

  def add_task_list(list)
    raise NoMethodError, '#add_task_list has been overridden in the User model (see documentation)'
  end

  # The ++before_destroy++ hook prevents the last admin user from being deleted.
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

  # The ++#tasks++ method returns an array of all the tasks the user owns,
  # regardless of which task list they belong to.

  def tasks
    (task_lists.map {|list| list.tasks.flatten }).flatten
  end

  # The ++#to_hash++ or ++:to_h++ method returns a hash of all the user's non-empty
  # attributes, including an array of the IDs of any task lists belonging to 
  # the user. Attributes that are empty or nil are not included in the hash,
  # so not all columns will be present in every hash.
  #
  # For security reasons, the password is not returned in the hash.

  def to_hash
    h = super.reject {|k,v| v.blank? || k === :password }
    h
  end

  alias_method :to_h, :to_hash

  # Override the ++#to_json++ method so the JSON object is created from the 
  # hash of the user's attributes instead of from the user object itself
  #
  # NOTE: The definition of ++#to_json++ has to include the optional ++opts++
  #       arg, because in some of the tests, a JSON::Ext::Generator::State
  #       object is passed to the method. I am not sure why this happens,
  #       but including the optional arg makes it work as expected.

  def to_json(opts={})
    to_h.to_json
  end

  # The ++validate++ method verifies that the user profile information is
  # valid, returning a ++Sequel::ValidationError++ if any of the conditions
  # are not met. The criteria are as follows:
  #
  # Required information:
  #   * ++:username++
  #   * ++:password++
  #   * ++:email++
  #   * ++:first_name++
  #   * ++:last_name++
  #
  # Required formatting:
  #   * ++:email++ must be of a valid e-mail format, which is to say it must 
  #     include ++@++ with some number of characters on either side (limited 
  #     to this test to accommodate edge cases)
  #   * ++:username++ must be at least 8 characters long
  #   * ++:password++ must be at least 8 characters long
  #
  # Additional requirements:
  #   * ++:username++ must be unique
  #   * ++:email++ must be unique
  #
  # FIX: Might be good to allow shorter usernames. Think about it.
  #
  # FIX: Add data standardization - capitalization of names and whatnot

  def validate
    super
    validates_presence [:username, :password, :email, :first_name, :last_name]
    validates_unique(:username, :email)
    validates_format /@/, :email, message: 'is not a valid e-mail address'
    validates_min_length 8, :username
    validates_min_length 8, :password
<<<<<<< HEAD
<<<<<<< HEAD
    validates_includes Data::STATES, :state if state
=======
    validates_includes Data::STATES, :state
>>>>>>> parent of 5385e5b... Verify that address details are included in the user's to_hash method
    validates_format /^\d{5}$/, :zip if zip
=======
>>>>>>> parent of 838b1b8... Add validations for new fields
  end
end
