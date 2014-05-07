class Categorization < ActiveRecord::Base
  belongs_to :todo_item
  belongs_to :category
end
