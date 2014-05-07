class Category < ActiveRecord::Base
  has_many :categorizations, foreign_key: :category_id
  has_many :todo_items, through: :categorizations
end
