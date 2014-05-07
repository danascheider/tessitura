class Category < ActiveRecord::Base
  has_many :categorizations
  has_many :todo_items, through: :categorizations
end
