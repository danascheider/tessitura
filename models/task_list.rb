class TaskList < Sequel::Model
  many_to_one :user
  one_to_many :tasks

  alias_method :owner, :user

  def before_destroy
    self.tasks.each(&:destroy)
  end

  def owner_id
    self.user.id 
  end

  def to_hashes
    self.tasks.map(&:to_h)
  end

  alias_method :to_a, :to_hashes

  def validate
    super
    validates_presence :user_id
    validates_numeric  :user_id
  end
end