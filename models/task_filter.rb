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
    tasks.where(parse_time_conditions!)
  end

  protected

    # The hash that is passed into the #one_sided_time_range method is the hash within
    # filters designating a date or time, for example:
    # => { deadline: { before: { year: 2014, month: 8, day: 22 } } }

    def parse_time_conditions!
      @time_conditions.each do |key, value|
        @time_conditions[key] = triage(key, value)
      end
    end

    def parse_datetime(date)
      Time.utc(date[:year], date[:month], date[:day])
    end

    # #sanitize! ensures that requested filters only consist of valid attributes

    def sanitize!(conditions)
      conditions = conditions.reject {|key, value| !TASK_ATTRIBUTES.include?(key) }
    end

    # #string_condition takes the following arguments:
    # * condition - :before or :after
    # * attr_name - the name of the attribute being filtered, e.g. :updated_at
    # * date_hash - the hash containing the date parameters, e.g. { year: 2014, month: 9, day: 17 }

    def string_condition(condition,attr_name,date_hash)
      condition == :before ? ["#{attr_name.to_s} < ?", parse_datetime(date_hash)] : ["#{attr_name.to_s} > ?", parse_datetime(date_hash)]
    end

    # Like the #one_sided_time_range method, #time_range takes a hash including the
    # name of the attribute in question:
    # => { before: { year: 2014, month: 8, day: 31 }, after: { year: 2014, month: 8, day: 1} }

    # This method also handles time conditions with the :on key:
    # => { created_at: { on: { year: 2014, month: 8, day: 12 } } } 

    def time_range(hash)
      hash.has_key?(:on) ? parse_datetime(hash[:on]) : nil
    end

    # The hash argument to the #triage and #use_range? methods is the value assigned to the attribute
    # being filtered for, e.g.:
    # => { on: { year: 2014, month: 9, day: 21 } }

    def triage(key, value)
      if value.length == 1 && !value.has_key?(:on)
        if value.respond_to?(:use_range?) && use_range?(value)
          @time_conditions[key] = time_range(key => value)
        else
          condition, kee, date_hash = value.values.first.keys.first, key.to_s, value.values.first
          string_condition(condition, kee, date_hash)
        end
      end
    end

    def use_range?(hash)
      hash.length == 2 || hash.has_key?(:on)
    end
end