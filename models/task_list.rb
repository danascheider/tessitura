class TaskList < Sequel::Model
  many_to_one :user
  one_to_many :tasks

  alias_method :owner, :user

  def owner_id
    self.user.id 
  end

  def validate
    super
    validates_presence :user_id
  end
end