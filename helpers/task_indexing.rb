class TaskIndexer
  def self.indices 
    @indices ||= Task.pluck(:index)
  end

  def self.update_indices(indices=nil)
    @indices ||= Task.pluck(:index)
    @indices.sort!
    @updatable = (gap = self.gap) && !(dup = self.dup) ? Task.all : Task.where.not(id: Task.last_updated.id)

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
    duplicates = indices.find {|index| @indices.count(index) == 2 }
  end

  def self.gap
    return nil unless Task.count > 1
    1.upto(indices.last) {|number| @gap = number unless @indices.include? number}
    @gap
  end

  def self.update(min, max, amt=1)
    @updatable.each {|task| task.increment!(:index, amt) if task.index.between?(min, max)}
  end
end