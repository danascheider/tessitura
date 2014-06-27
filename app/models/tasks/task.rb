class Task < ActiveRecord::Base
  def incomplete?
    !self.complete
  end
end