class User < ActiveRecord::Base
  has_many :todo_items, dependent: :destroy, foreign_key: :user_id
  validates_associated :todo_items
  validates :username, :password, :email, presence: true
  validates :username, uniqueness: true
end
