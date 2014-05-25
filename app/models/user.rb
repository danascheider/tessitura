class User < ActiveRecord::Base
  has_many :todo_items, dependent: :destroy, foreign_key: :user_id
  validates :username, presence: true
end
