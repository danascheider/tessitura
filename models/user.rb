class User < ActiveRecord::Base
  def admin?
    self.admin 
  end

  def name
    "#{self.first_name} #{self.last_name}"
  end
end