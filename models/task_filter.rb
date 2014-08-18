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
    tasks = @scope.where(@categorical_conditions) if @categorical_conditions
    tasks = tasks.where(parse_conditions!(@time_conditions)) if @time_conditions
  end

  protected
    def parse_conditions!(conditions)
      conditions.each do |key, value|
        if value.length == 1
          if value.has_key? :on
            conditions[key] = parse_datetime(value[:on])
          else
            return one_sided_time_range(conditions)
          end
        else
          conditions[key] = (parse_datetime(value[:after])..parse_datetime(value[:before]))
        end
      end
    end

    # The hash that is passed into the #one_sided_time_range method is the hash within
    # filters designating a date or time, for example:
    # => { deadline: { before: { year: 2014, month: 8, day: 22 } } }

    def one_sided_time_range(hash)
      attribute = hash[attr_name = hash.keys.first]
      string_condition(attribute.keys.first,attr_name,attribute.values.first)
    end

    def parse_datetime(date)
      year, month, day = date[:year], date[:month], date[:day]
      Time.utc(year, month, day)
    end

    # #string_condition takes the following arguments:
    # * condition - :before or :after
    # * attr_name - the name of the attribute being filtered, e.g. :updated_at
    # * date_hash - the hash containing the date parameters, e.g. { year: 2014, month: 9, day: 17 }

    def string_condition(condition,attr_name,date_hash)
      condition == :before ? ["#{attr_name.to_s} < ?", parse_datetime(date_hash)] : ["#{attr_name.to_s} > ?", parse_datetime(date_hash)]
    end

    def sanitize!(conditions)
      conditions = conditions.reject {|key, value| !TASK_ATTRIBUTES.include?(key) }
    end
end