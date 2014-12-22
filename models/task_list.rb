class TaskList < Sequel::Model
  many_to_one :user
  one_to_many :tasks

  alias_method :owner, :user

  # Due to foreign key constraints not placated by the `:association_dependencies`
  # plugin, the `#before_destroy` hook destroys each of the list's tasks before
  # destroying the list itself.

  def before_destroy
    tasks.each(&:destroy)
  end

  # The `#owner_id` method is standard for Canto models that can be said to have
  # a single owner (i.e., models that would use `belongs_to` syntax in ActiveRecord).
  # The `#owner_id` points to the single owner of the resource.

  def owner_id
    user.id 
  end

  # The `#to_hashes` method, aliased as `#to_a`, returns an array with all of the 
  # tasks on the calling list rendered as hashes.

  def to_hashes
    tasks.map(&:to_h)
  end

  alias_method :to_a, :to_hashes

  # The `#to_json` method converts the output of `#to_hash` to JSON format, preventing
  # inscrutable JSON objects like `"\"#<TaskList:0x00000004b050c8>\""`.

  def to_json
    to_a.to_json
  end

  def validate
    super
    validates_presence :user_id
    validates_numeric  :user_id
  end
end