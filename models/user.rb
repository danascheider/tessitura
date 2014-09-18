class User < Sequel::Model
  one_to_many :task_lists

  def self.admin 
    User.where(admin: true)
  end

  def admin?
    self.admin ? true : false
  end

  def before_destroy
    false if self.admin? && User.admin.count == 1
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

  def tasks
    self.task_lists.map {|list| list.tasks }
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

  def validate
    super
    validates_presence [:username, :password, :email]
    validates_unique(:username, :email)
    validates_format /@/, :email, message: 'is not a valid e-mail address'
    validates_min_length 8, :username
    validates_min_length 8, :password
  end
end
