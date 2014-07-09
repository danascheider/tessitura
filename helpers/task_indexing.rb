class TaskIndexer
  @@indices ||= Task.pluck(:index).sort

  def self.indices 
    @@indices 
  end

  def self.refresh_index_array(new_indices=nil)
    @@indices = new_indices || Task.pluck(:index)
    @@indices.sort! unless @@indices == nil
  end

  def self.updatable
    @updatable
  end

  def self.update_indices(indices=nil)
    @@indices = indices || Task.pluck(:index).sort
    @@indices.sort!
    dup, gap = self.dup, self.gap
    @updatable = gap && !dup ? Task.all : Task.where.not(id: Task.last_updated.id)

    if dup && gap
      dup > gap ? update(gap + 1, dup, -1) : update(dup, gap - 1)
    elsif dup
      update(dup, Task.max_index + 1)
    elsif gap 
      update(gap, Task.max_index, -1)
    end
  end

  def self.dup
    return nil unless Task.count > 1
    duplicates = @@indices.find {|index| @@indices.count(index) == 2 }
  end

  def self.gap
    return nil unless (Task.count > 1) && @@indices[-1].is_a?(Integer) && @@indices[-1] > 1
    ((1..@@indices[-1]).to_a - @@indices)[0]
  end

  def self.update(min, max, amt=1)
    @updatable.each {|task| task.increment!(:index, amt) if task.index.between?(min, max)}
  end
end