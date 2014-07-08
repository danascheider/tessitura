module TaskIndexing
  def update_indices(indices=nil)
    @indices ||= Task.pluck(:index)
    @indices.sort!
    @updatable = gap && !dup ? Task.all : Task.where.not(id: Task.last_updated.id)

    if dup && gap
      dup > gap ? update(gap + 1, dup, -1) : update(dup, gap - 1)
    elsif dup
      update(dup, Task.max_index + 1)
    elsif gap 
      update(gap, Task.max_index, -1)
    end
  end

  protected
    def dup
      return nil unless Task.count > 1
      @indices.each {|index| return index if @indices.count(index) == 2 }
    end

    def gap
      return nil unless Task.count > 2
      gap = [1..@indices[-1]].to_a - @indices.uniq
      return gap ? gap[0] : nil
    end

    def update(min, max, amt)
      @updatable.each {|task| task.increment(:index, amt) if task.index.between?(min, max)}
    end
end