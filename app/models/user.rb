class User < ActiveRecord::Base
  has_many :todo_items, dependent: :destroy, foreign_key: :user_id
  validates_associated :todo_items
  validates :username, :password, :email, presence: true
  validates :username, uniqueness: true
  validates :password, length: { minimum: 8, too_short: "Password must be at least 8 characters long." }

  def admin?
    self.is_admin
  end

  def authenticate(password)
    password == self.password 
  end
end
