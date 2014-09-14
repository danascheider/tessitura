class User < Sequel::Model
  def admin?
    self.admin ? true : false
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
      created_at: self.created_at
      updated_at: self.updated_at
    }
  end
end
