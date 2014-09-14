class User < Sequel::Model
  self.subset(:admin) { admin == true }

  def admin?
    self.admin ? true : false
  end

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def owner_id
    self.id 
  end

  def to_hash
    {
      id: self.id,
      username: self.username,
      email: self.email,
      first_name: self.first_name,
      last_name: self.last_name,
      city: self.city,
      country: self.country,
      fach: self.fach,
      admin: self.admin,
      created_at: self.created_at,
      updated_at: self.updated_at
    }
  end

  def validate
    super
    validates_presence [:username, :password, :email]
    validates_unique [:username, :email]
    validates_format /@/, :email, message: 'is not a valid e-mail address'
    validates_min_length 8, :username
    validates_min_length 8, :password
  end
end
