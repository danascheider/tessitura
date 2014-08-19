require 'date'

class TaskFilter
  attr_accessor :conditions

  TASK_ATTRIBUTES = [ :created_at, :deadline, :description, :position, :priority, :status, :task_list_id, :title, :updated_at ]
  RANGE_OPTIONS   = [ :after, :before, :on ]
  TIME_FIELDS     = [ :created_at, :deadline, :updated_at ]

  def initialize(conditions, owner_id)
    @categorical_conditions = sanitize!(conditions).reject {|key, val| TIME_FIELDS.include?(key) }
    @time_conditions = conditions.reject {|key, value| @categorical_conditions.include?(key) }
    @scope = Task.where(owner_id: User.find(owner_id))
  end

  def filter
    @scope = @scope.where(@categorical_conditions) if @categorical_conditions
    parse_time_conditions! if @time_conditions
    @scope.where(@time_conditions) if @time_conditions
  end

  protected

    # The hash that is passed into the #one_sided_time_range method is the hash within
    # filters designating a date or time, for example:
    # => { deadline: { before: { year: 2014, month: 8, day: 22 } } }

    def parse_time_conditions!
      @time_conditions.dup.each do |key, value|
        if value.has_key?(:on)
          @time_conditions[key] = parse_datetime(value[:on])
          next
        else
          @time_conditions[key][:before] ||= {year: 3000, month: 1, day: 1}
          @time_conditions[key][:after] ||= {year: 1000, month: 1, day: 1}
          before_date, after_date = parse_datetime(@time_conditions[key][:before]), parse_datetime(@time_conditions[key][:after])
          @time_conditions[key] = ((after_date + 1.day)..(before_date - 1.day))
        end
      end
    end

    def parse_datetime(date)
      return if date.is_a?(Time)
      Time.utc(date[:year], date[:month], date[:day])
    end

    # The #sanitize! method makes sure conditions passed in are valid task attributes
    # by deleting any key-value pairs where the key is not a member of the
    # TASK_ATTRIBUTES array

    def sanitize!(conditions)
      conditions.reject {|key, value| !TASK_ATTRIBUTES.include?(key) }
    end
end