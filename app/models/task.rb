class Task < ActiveRecord::Base
  def complete?
    self.complete
  end
end
