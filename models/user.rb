class User < ActiveRecord::Base
  before_create :set_admin_status
  def admin?
    self.admin 
  end

  def name
    "#{self.first_name} #{self.last_name}"
  end

  private
    def set_admin_status
      self.admin = true if User.count == 0
    end
end