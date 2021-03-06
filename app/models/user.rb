class User < ActiveRecord::Base
  attr_reader :password

  validates :password_digest, :username, :session_token, presence: true
  validates :username, uniqueness: true
  validates :password, length: {minimum: 6, allow_nil: true}

  after_initialize :ensure_session_token

  has_many :goals
  has_many :comments,
    primary_key: :id,
    foreign_key: :author_id,
    class_name: :Comment

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.generate_session_token
    SecureRandom.urlsafe_base64(32)
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.find_by_credentials(username, password)
    user = User.find_by_username(username)
    if user
      return user if user.is_password?(password)
    end
    nil
  end

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

end
