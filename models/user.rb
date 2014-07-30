require 'securerandom'

class User < ActiveRecord::Base
  has_many :task_lists, dependent: :destroy
  validates :email, presence: true, uniqueness: true, 
                    format: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :username, presence: true, uniqueness: true,
                       length: { in: 8..50 }
  validates :password, presence: true, confirmation: true,
                       length: { in: 8..100 }
  before_create :set_admin_status

  # FIX: This belongs in the AuthorizationHelper module
  def self.is_admin_key?(key)
    user = User.find_by(secret_key: key)
    true if user && user.admin
  end
  
  def admin?
    self.admin 
  end

  def default_task_list
    self.task_lists.first || TaskList.create(title: 'Default List', user_id: self.id)
  end

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def to_hash
    { 
      id: self.id,
      first_name: self.first_name,
      last_name: self.last_name,
      email: self.email,
      fach: self.fach,
      birthdate: self.birthdate,
      city: self.city,
      country: self.country,
      admin: self.admin
    }.delete_if {|key, value| value == nil }
  end

  def tasks
    user_tasks = []
    self.task_lists.all.each {|list| user_tasks << list.tasks }
    user_tasks.flatten!
  end

  private
    def set_admin_status
      self.admin = true if User.count == 0
    end
end