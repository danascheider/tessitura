require 'date'

class TaskFilter
  attr_accessor :conditions

  TASK_ATTRIBUTES = [ :created_at, :deadline, :description, :position, :priority, :status, :task_list_id, :title, :updated_at ]
  RANGE_OPTIONS   = [ :after, :before, :on ]
  TIME_FIELDS     = [ :created_at, :deadline, :updated_at ]

  def initialize(conditions, owner_id)
    @conditions = sanitize!(conditions)
    @scope = Task.where(owner_id: User.find(owner_id))
  end

  def filter
    @scope.where(parse_conditions!)
  end

  protected

    def time_value?(key)
      TIME_FIELDS.include?(key)
    end

    def parse_conditions!
      @conditions.dup.each {|key, value| @conditions[key] = time_value?(key) ? time_value(key) : value }
      @conditions
    end

    def parse_datetime(date)
      return date unless date.is_a?(Hash)
      Time.utc(date[:year], date[:month], date[:day])
    end

    # The #sanitize! method makes sure conditions passed in are valid task attributes
    # by deleting any key-value pairs where the key is not a member of the
    # TASK_ATTRIBUTES array

    def sanitize!(conditions)
      conditions.reject {|key, value| !TASK_ATTRIBUTES.include?(key) }
    end

    def get_range(key)
      before = parse_datetime(@conditions[key][:before]) || Time.utc(3000,1,1)
      after = parse_datetime(@conditions[key][:after]) || Time.utc(1000,1,1)
      ((after + 1.day)..(before - 1.day))
    end

    def time_value(key)
      @conditions[key].has_key?(:on) ? parse_datetime(@conditions[key][:on]) : get_range(key)
    end
end