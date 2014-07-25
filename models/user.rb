require 'securerandom'

class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true, 
                    format: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :secret_key, presence: true, on: :update
  before_create :set_admin_status
  before_create :issue_api_key

  def self.is_admin_key?(key)
    user = User.find_by(secret_key: key)
    true if user && user.admin
  end

  def admin?
    self.admin 
  end

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def to_hash
    { 
      first_name: self.first_name,
      last_name: self.last_name,
      email: self.email,
      fach: self.fach,
      birthdate: self.birthdate,
      city: self.city,
      country: self.country,
      admin: self.admin
    }.delete_if {|key, value| value == nil }
  end

  private
    def issue_api_key
      self.secret_key = SecureRandom.urlsafe_base64(30)
    end

    def set_admin_status
      self.admin = true if User.count == 0
    end
end