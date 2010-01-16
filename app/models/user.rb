class User
  def initialize(attributes)
    @attributes = attributes
  end

  def id
    @attributes[:user_id]
  end

  def email
    @attributes[:email]
  end

  def to_liquid
    {'id' => id, 'email' => email}
  end
end
