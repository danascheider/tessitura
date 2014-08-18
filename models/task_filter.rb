require 'date'

class TaskFilter
  attr_accessor :conditions

  TASK_ATTRIBUTES = [ :created_at, :deadline, :description, :position, :priority, :status, :task_list_id, :title, :updated_at ]
  RANGE_OPTIONS   = [ :after, :before, :on ]
  TIME_FIELDS     = [ :created_at, :deadline, :updated_at ]

  def initialize(conditions, owner_id)
    @conditions = conditions.reject {|key, val| !TASK_ATTRIBUTES.include?(key) }
    @conditions[:owner_id] = owner_id
  end

  def filter
    Task.where(parse_conditions!)
  end

  protected
    def parse_conditions!
      @conditions.each do |key, value|
        if TIME_FIELDS.include?(key)
          if value.length == 1
            if value.has_key? :on
              @conditions[key] = parse_datetime(value[:on])
            elsif value.has_key? :after
              @conditions[key] = [" > ?", parse_datetime(value[:after])]
            else
              @conditions[key] = [" < ?", parse_datetime(value[:before])]
            end
          else
            @conditions[key] = (parse_datetime(value[:after])..parse_datetime(value[:before]))
          end
        end
      end
    end

    def parse_datetime(date)
      year, month, day = date[:year], date[:month], date[:day]
      Time.utc(year, month, day)
    end
end