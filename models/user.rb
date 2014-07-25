require 'securerandom'

class User < ActiveRecord::Base
  before_create :set_admin_status
  before_create :issue_api_key

  def admin?
    self.admin 
  end

  def name
    "#{self.first_name} #{self.last_name}"
  end

  private
    def issue_api_key
      self.secret_key = SecureRandom.urlsafe_base64(30)
    end

    def set_admin_status
      self.admin = true if User.count == 0
    end
end