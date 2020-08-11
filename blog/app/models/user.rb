class User < ApplicationRecord
  PERMIT_ATTRIBUTES = %i(name email password password_confirmation).freeze
  attr_accessor :remember_token

  validates :name, presence: true, length: {maximum: Settings.number.max_name}
  validates :email, presence: true,
      length: {maximum: Settings.number.max_email},
      format: {with: Settings.text.string_validate},
             uniqueness: {case_sensitive: false}
  validates :password, presence: true,
      length: {minimum: Settings.number.min_pass}

  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    return false unless remember_digest

    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update remember_digest: nil
  end

  before_save :downcase_email

  private

  def downcase_email
    email.downcase!
  end
end
