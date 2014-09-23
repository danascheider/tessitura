class User < Sequel::Model
  one_to_many :task_lists

  def self.admin 
    User.where(admin: true)
  end

  def admin?
    self.admin ? true : false
  end

  def before_destroy
    return false if self.admin? && User.admin.count == 1
    self.remove_all_task_lists
  end

  def default_task_list
    self.task_lists.length > 0 ? self.task_lists.first : TaskList.create(title: "Default Task List", user: self)
  end

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def owner_id
    self.id 
  end

  def remove_all_task_lists
    self.task_lists.each {|list| list.destroy }
    self.reload # to prevent lists from being cached
  end

  # This method is added automatically by Sequel and has been overridden
  # here so as not to interfere with the foreign key constraint on the table

  def remove_task_list(list)
    list.destroy
    self.reload # to prevent list from being cached
  end

  def tasks
    arr = self.task_lists.map {|list| list.tasks.flatten }
    arr.flatten!
  end

  def tasks_dataset
    DB[:tasks].filter(owner_id: self.id)
  end

  def to_hash
    {
      id: self.id,
      username: self.username,
      email: self.email,
      first_name: self.first_name,
      last_name: self.last_name,
      city: self.city,
      country: self.country,
      fach: self.fach,
      admin: self.admin,
      task_lists: self.task_lists.map {|list| list.id },
      created_at: self.created_at,
      updated_at: self.updated_at
    }.reject! {|k,v| [nil, false, [], {}, ''].include? v }
  end

  def to_json(options={})
    self.to_hash.to_json
  end

  def validate
    super
    validates_presence [:username, :password, :email]
    validates_unique(:username, :email)
    validates_format /@/, :email, message: 'is not a valid e-mail address'
    validates_min_length 8, :username
    validates_min_length 8, :password
  end
end
