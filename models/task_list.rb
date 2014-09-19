class TaskList < Sequel::Model
  many_to_one :user
  one_to_many :tasks

  alias_method :owner, :user

  def owner_id
    self.user.id 
  end

  def to_hashes
    self.tasks.map {|task| task.to_hash }
  end

  alias_method :to_a, :to_hashes

  def validate
    super
    validates_presence :user_id
  end
end